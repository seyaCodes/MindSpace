import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../data/providers/arc_providers.dart';
import '../../../../data/providers/reflection_providers.dart';
import '../../../../services/chat_pipeline_service.dart';
import '../../../../services/llm_service.dart';
import '../../../analysis/data/providers/analysis_providers.dart';
import '../../../history/data/providers/history_providers.dart';
import '../../data/providers/chat_providers.dart';
import '../../data/repositories/chat_repository.dart';
import '../widgets/chat_arc_banner.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  String? _chatId;
  final List<_ChatMessage> _messages = [];
  bool _initializing = true;
  bool _sending = false;
  bool _wrappingUp = false;
  int _userMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Initialisation ────────────────────────────────────────────

  Future<void> _initChat() async {
    try {
      final chat = await ref.read(chatRepositoryProvider).createChat();
      if (mounted) {
        setState(() {
          _chatId = chat.id;
          _initializing = false;
        });
      }
    } catch (e) {
      debugPrint('[ChatScreen] initChat error: $e');
      if (mounted) setState(() => _initializing = false);
    }
  }

  // ── Messaging ─────────────────────────────────────────────────

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _chatId == null || _sending || _wrappingUp) return;

    _controller.clear();
    setState(() {
      _sending = true;
      _userMessageCount++;
      _messages.add(_ChatMessage(role: 'user', content: text));
    });
    _scrollToBottom();

    final assistantIndex = _messages.length;
    setState(() => _messages.add(_ChatMessage(role: 'assistant', content: '')));

    try {
      String fullResponse = '';
      await for (final token in ref.read(llmServiceProvider).streamChat(
        chatId: _chatId!,
        content: text,
      )) {
        fullResponse += token;
        if (mounted) {
          setState(() {
            _messages[assistantIndex] =
                _ChatMessage(role: 'assistant', content: fullResponse);
          });
          _scrollToBottom();
        }
      }
    } catch (e) {
      debugPrint('[ChatScreen] stream error: $e');
      if (mounted) {
        setState(() {
          _messages[assistantIndex] = const _ChatMessage(
            role: 'assistant',
            content: "Sage couldn't respond right now. Try again.",
          );
        });
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  // ── Wrap-up ───────────────────────────────────────────────────

  Future<void> _wrapUpSession() async {
    if (_chatId == null || _wrappingUp || _sending) return;
    setState(() => _wrappingUp = true);

    try {
      await ref
          .read(chatPipelineServiceProvider)
          .wrapUpSession(chatId: _chatId!);

      _invalidateStaleProviders();

      // Navigate to the wrap-up reflection screen, replacing the chat in the stack.
      if (mounted) {
        context.pushReplacement('${AppRoutes.wrapUp}/$_chatId');
      }
    } catch (e) {
      debugPrint('[ChatScreen] wrapUp error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrap up failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() => _wrappingUp = false);
      }
    }
  }

  // ── Back navigation ───────────────────────────────────────────

  /// Intercepts the back gesture/button.
  ///
  /// • 0 messages sent → archive the empty chat, pop immediately.
  /// • 1+ messages sent → trigger wrap-up pipeline, then pop.
  /// • Already wrapping up or sending → ignore.
  Future<void> _handleBack() async {
    if (_wrappingUp || _sending) return;

    if (_userMessageCount == 0) {
      // Nothing meaningful happened — soft-delete the empty chat.
      if (_chatId != null) {
        try {
          await ref.read(chatRepositoryProvider).archiveChat(_chatId!);
        } catch (_) {
          // Best-effort; don't block navigation.
        }
      }
      if (mounted) Navigator.of(context).pop();
      return;
    }

    // Conversation happened — run the full wrap-up.
    await _wrapUpSession();
  }

  // ── Provider invalidation ─────────────────────────────────────

  void _invalidateStaleProviders() {
    // Arc-level
    ref.invalidate(arcsProvider);
    ref.invalidate(arcProvider);
    ref.invalidate(arcInsightsByArcProvider);
    // Reflection-level
    ref.invalidate(reflectionProvider);
    ref.invalidate(reflectionsByArcProvider);
    // Chat-level
    ref.invalidate(chatsProvider);
    ref.invalidate(messagesProvider);
    // History screen providers (now public so they can be invalidated here)
    ref.invalidate(historyTimelineProvider);
    ref.invalidate(historyActiveArcsProvider);
    ref.invalidate(historyArchivedArcsProvider);
    // Analysis dashboard
    ref.invalidate(analysisStatsProvider);
    ref.invalidate(heatmapProvider);
    ref.invalidate(arcInsightsProvider);
  }

  // ── Scroll ────────────────────────────────────────────────────

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final showWrapUp = _userMessageCount >= 4 && !_wrappingUp;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF5635A8), Color(0xFF0D1B3E)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _ChatHeader(
                  onBack: () => _handleBack(),
                  showWrapUp: showWrapUp,
                  onWrapUp: _wrapUpSession,
                ),
                if (_wrappingUp)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF6EECD4),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Sage is sitting with this...',
                          style: TextStyle(
                            color: Color(0xFF6EECD4),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: _initializing
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white54,
                          ),
                        )
                      : _messages.isEmpty
                          ? const ChatArcBanner()
                          : ListView.builder(
                              controller: _scrollController,
                              padding:
                                  const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              itemCount: _messages.length,
                              itemBuilder: (_, i) =>
                                  _MessageBubble(message: _messages[i]),
                            ),
                ),
                ChatInputBar(
                  controller: _controller,
                  onSend: _sendMessage,
                  loading: _sending,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Local message model ───────────────────────────────────────────────────────

class _ChatMessage {
  final String role;
  final String content;

  const _ChatMessage({required this.role, required this.content});
}

// ── Header ────────────────────────────────────────────────────────────────────

class _ChatHeader extends StatelessWidget {
  final VoidCallback onBack;
  final bool showWrapUp;
  final VoidCallback onWrapUp;

  const _ChatHeader({
    required this.onBack,
    required this.showWrapUp,
    required this.onWrapUp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: onBack,
          ),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Sage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'listening',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          if (showWrapUp)
            GestureDetector(
              onTap: onWrapUp,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA78BCA), Color(0xFF6EECD4)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Wrap Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFC89BFF), Color(0xFFA970FF)],
                ),
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 14,
                color: Colors.white,
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFFA970FF)
                    : Colors.white.withOpacity(.07),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
              ),
              child: Text(
                message.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
