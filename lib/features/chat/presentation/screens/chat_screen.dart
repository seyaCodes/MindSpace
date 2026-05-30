import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/chat_pipeline_service.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/message_repository.dart';
import '../../domain/models/message_model.dart';
import '../widgets/chat_arc_banner.dart';
import '../widgets/chat_header.dart';
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
  final List<MessageModel> _messages = [];
  bool _initializing = true;
  bool _sending = false;

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

  Future<void> _initChat() async {
    try {
      final chat = await ref.read(chatRepositoryProvider).createChat();
      if (mounted) setState(() { _chatId = chat.id; _initializing = false; });
    } catch (_) {
      if (mounted) setState(() => _initializing = false);
    }
  }

  Future<void> _sendMessage() async {
  final text = _controller.text.trim();

  if (text.isEmpty || _chatId == null || _sending) {
    return;
  }

  _controller.clear();

  setState(() {
    _sending = true;
  });

  try {
    final message = await ref
        .read(messageRepositoryProvider)
        .createMessage(
          chatId: _chatId!,
          role: 'user',
          content: text,
        );

    setState(() {
      _messages.add(message);
    });

    _scrollToBottom();

    if (_messages.length == 1) {
      await ref.read(chatPipelineServiceProvider).processFirstMessage(
            chatId: _chatId!,
          );
    }
  } catch (e) {
    debugPrint('[ChatScreen] sendMessage error: $e');
  } finally {
    if (mounted) {
      setState(() {
        _sending = false;
      });
    }
  }
}







  Future<void> _closeChat() async {
    if (mounted) Navigator.of(context).pop();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ChatHeader(onBack: _closeChat),
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
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;

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
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .72,
            ),
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
        ],
      ),
    );
  }
}
