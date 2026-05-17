import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../core/constants/quick_replies.dart';
import '../../core/widgets/pressable_scale.dart';

// ── Mock messages ─────────────────────────────────────────────────────────────
class _Msg {
  final bool isUser;
  final String text;
  final String? time;
  const _Msg({required this.isUser, required this.text, this.time});
}

final _freeMessages = [
  _Msg(isUser: false,
      text: "Hey, Seya. No pressure to know where this is going — we can just start. What's sitting closest to the surface tonight?",
      time: '7:42 PM'),
];

final _arcMessages = [
  _Msg(isUser: false,
      text: 'Welcome back. You\'re here a little earlier than the spike usually shows up. That feels like a small win on its own.',
      time: '9:02 PM'),
  _Msg(isUser: true,
      text: 'I noticed I was starting to spiral and just opened the app.',
      time: '9:03 PM'),
  _Msg(isUser: false,
      text: 'That\'s the move. What does the spiral sound like tonight — the same voice as last week, or different?',
      time: '9:03 PM'),
  _Msg(isUser: true,
      text: 'Same voice. "If you don\'t get this one, you\'re cooked."',
      time: '9:04 PM'),
];

// ── Provider ──────────────────────────────────────────────────────────────────
final _messagesProvider = StateProvider.family<List<_Msg>, String?>((ref, arcId) {
  return arcId != null ? List.from(_arcMessages) : List.from(_freeMessages);
});
final _showQuickRepliesProvider = StateProvider.family<bool, String?>((ref, arcId) {
  return arcId == null; // only show on free chat with no messages sent
});

// ── Screen ────────────────────────────────────────────────────────────────────
class ChatScreen extends ConsumerStatefulWidget {
  final String? arcId;
  const ChatScreen({super.key, this.arcId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _showMenuSheet = false;

  bool get _inArc => widget.arcId != null;

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    ref.read(_messagesProvider(widget.arcId).notifier).update((msgs) => [
          ...msgs,
          _Msg(isUser: true, text: text.trim(), time: '9:05 PM'),
        ]);
    ref.read(_showQuickRepliesProvider(widget.arcId).notifier).state = false;
    _ctrl.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(_messagesProvider(widget.arcId));
    final showQR = ref.watch(_showQuickRepliesProvider(widget.arcId));

    return Scaffold(
      backgroundColor: const Color(0xFF0E1340),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3D2B7A),
                  Color(0xFF1A1F5E),
                  Color(0xFF0E1340),
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),
          Column(
            children: [
              _ChatHeader(
                arcId: widget.arcId,
                onBack: () => context.pop(),
                onMenu: () => setState(() => _showMenuSheet = true),
              ),
              // Session label
              if (_inArc)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SESSION 6 · THE JOB HUNT',
                          style: GoogleFonts.inter(
                              color: AppColors.accentPurple, fontSize: 11,
                              fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                      const SizedBox(height: 6),
                      Text('Picking back up — what\'s shifted?',
                          style: GoogleFonts.inter(
                              color: AppColors.textPrimary, fontSize: 22,
                              fontWeight: FontWeight.w700, height: 1.2)),
                      const SizedBox(height: 16),
                      // Last time card
                      _LastTimeCard(),
                      const SizedBox(height: 16),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NEW SESSION · JUST TALKING',
                          style: GoogleFonts.inter(
                              color: AppColors.textTertiary, fontSize: 11,
                              fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                      const SizedBox(height: 6),
                      Text('What\'s with you, right now?',
                          style: GoogleFonts.inter(
                              color: AppColors.textPrimary, fontSize: 22,
                              fontWeight: FontWeight.w700, height: 1.2)),
                    ],
                  ),
                ),
              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: messages.length + (showQR ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (showQR && i == messages.length) {
                      return _QuickReplies(onTap: _sendMessage);
                    }
                    return _MessageBubble(msg: messages[i]);
                  },
                ),
              ),
              // Input bar
              _InputBar(
                controller: _ctrl,
                onSend: () => _sendMessage(_ctrl.text),
              ),
            ],
          ),
          // Menu sheet overlay
          if (_showMenuSheet)
            _ChatMenuSheet(
              onClose: () => setState(() => _showMenuSheet = false),
              onWrapUp: () {
                setState(() => _showMenuSheet = false);
                context.push('/reflection?id=mock_reflection_1');
              },
            ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _ChatHeader extends StatelessWidget {
  final String? arcId;
  final VoidCallback onBack;
  final VoidCallback onMenu;
  const _ChatHeader({required this.arcId, required this.onBack, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack,
              child: Row(
                children: [
                  const Icon(Icons.chevron_left,
                      color: AppColors.textSecondary, size: 22),
                  Text(arcId != null ? 'Threads' : 'Home',
                      style: GoogleFonts.inter(
                          color: AppColors.textSecondary, fontSize: 15)),
                ],
              ),
            ),
            const Spacer(),
            if (arcId != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.folder_outlined,
                        size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text('The Job Hunt',
                        style: GoogleFonts.inter(
                            color: AppColors.textPrimary, fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                      color: AppColors.border, width: 1,
                      style: BorderStyle.solid),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 13, color: AppColors.textTertiary),
                    const SizedBox(width: 5),
                    Text('no arc yet',
                        style: GoogleFonts.inter(
                            color: AppColors.textTertiary, fontSize: 12)),
                  ],
                ),
              ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onMenu,
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bgCard,
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: const Icon(Icons.more_horiz,
                    color: AppColors.textSecondary, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Last time card ────────────────────────────────────────────────────────────
class _LastTimeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
            color: AppColors.accentPurple.withOpacity(0.2), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.access_time_outlined,
              color: AppColors.accentPurple, size: 15),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Last time · ',
                    style: GoogleFonts.inter(
                        color: AppColors.textSecondary, fontSize: 13,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text: 'you named the fear as "being seen as not enough." '
                        'You wanted to try a 9 PM check-in before something big.',
                    style: GoogleFonts.inter(
                        color: AppColors.textSecondary, fontSize: 13,
                        height: 1.4)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final _Msg msg;
  const _MessageBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment:
            msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!msg.isUser)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 32, height: 32,
                  margin: const EdgeInsets.only(right: 8, bottom: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentPurple.withOpacity(0.2),
                  ),
                  child: const Center(
                    child: Text('✦',
                        style: TextStyle(
                            color: AppColors.accentPurple, fontSize: 14)),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2260),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.08), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA78BFA).withOpacity(0.15),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(msg.text,
                        style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                            fontSize: 15, height: 1.5)),
                  ),
                ),
              ],
            )
          else
            Container(
              margin: const EdgeInsets.only(left: 48),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF3A2D7C),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                border: Border.all(
                    color: Colors.white.withOpacity(0.08), width: 1),
              ),
              child: Text(msg.text,
                  style: GoogleFonts.inter(
                      color: Colors.white, fontSize: 15, height: 1.5)),
            ),
          if (msg.time != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8, left: 48, right: 4),
              child: Text(msg.time!,
                  style: GoogleFonts.inter(
                      color: AppColors.textTertiary, fontSize: 11)),
            ),
        ],
      ),
    );
  }
}

// ── Quick reply chips ─────────────────────────────────────────────────────────
class _QuickReplies extends StatelessWidget {
  final ValueChanged<String> onTap;
  const _QuickReplies({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Wrap(
        spacing: 8, runSpacing: 8,
        children: kQuickReplies.map((q) => PressableScale(
          onTap: () => onTap(q),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Text(q,
                style: GoogleFonts.inter(
                    color: AppColors.textSecondary, fontSize: 14)),
          ),
        )).toList(),
      ),
    );
  }
}

// ── Input bar ─────────────────────────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        border: Border(
            top: BorderSide(color: AppColors.border.withOpacity(0.5), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: GoogleFonts.inter(
                          color: AppColors.textPrimary, fontSize: 15),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Message Sage...',
                        hintStyle: GoogleFonts.inter(
                            color: AppColors.textTertiary, fontSize: 15),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.mic_none,
                      color: AppColors.textTertiary, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentPurple,
              ),
              child: const Icon(Icons.arrow_forward,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chat menu bottom sheet ────────────────────────────────────────────────────
class _ChatMenuSheet extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onWrapUp;
  const _ChatMenuSheet({required this.onClose, required this.onWrapUp});

  @override
  State<_ChatMenuSheet> createState() => _ChatMenuSheetState();
}

class _ChatMenuSheetState extends State<_ChatMenuSheet> {
  bool _sessionsExpanded = false;

  static const _pastSessions = [
    (title: 'The pressure isn\'t about the job', date: 'Apr 25 · 7:30 PM'),
    (title: 'A quiet kind of readiness',         date: 'Apr 25 · 9:15 AM'),
    (title: 'The waiting game',                  date: 'Apr 22 · 10:30 PM'),
    (title: 'Why this loop again',               date: 'Apr 20 · 8:14 PM'),
    (title: 'Starting over isn\'t a setback',    date: 'Apr 11 · 6:02 PM'),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 36, height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Arc context card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.accentPurple.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.accentPurple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.folder_outlined,
                                  color: AppColors.accentPurple, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('The Job Hunt',
                                      style: GoogleFonts.inter(
                                          color: AppColors.textPrimary,
                                          fontSize: 15, fontWeight: FontWeight.w600)),
                                  Text('5 sessions · dominant',
                                      style: GoogleFonts.inter(
                                          color: AppColors.textSecondary,
                                          fontSize: 12)),
                                  Text('Anxious',
                                      style: GoogleFonts.inter(
                                          color: AppColors.accentPurple,
                                          fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            Text('this session',
                                style: GoogleFonts.inter(
                                    color: AppColors.textTertiary, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Re-routing option
                    _SheetRow(
                      icon: Icons.auto_awesome_outlined,
                      title: 'This feels like it belongs to...',
                      subtitle: 'Suggest a different arc · still confirmed by ML',
                      trailing: const Icon(Icons.chevron_right,
                          color: AppColors.textTertiary, size: 18),
                    ),
                    // Past sessions toggle
                    GestureDetector(
                      onTap: () => setState(() => _sessionsExpanded = !_sessionsExpanded),
                      child: _SheetRow(
                        icon: Icons.calendar_view_week_outlined,
                        title: 'View past sessions in this arc',
                        subtitle: '5 sessions · timeline below',
                        trailing: Icon(
                          _sessionsExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.textTertiary, size: 18,
                        ),
                      ),
                    ),
                    if (_sessionsExpanded)
                      ..._pastSessions.map((s) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentPurple.withOpacity(0.15),
                              ),
                              child: const Center(
                                child: Text('✦',
                                    style: TextStyle(
                                        color: AppColors.accentPurple,
                                        fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.title,
                                      style: GoogleFonts.inter(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  Text(s.date,
                                      style: GoogleFonts.inter(
                                          color: AppColors.textTertiary,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward,
                                color: AppColors.textTertiary, size: 16),
                          ],
                        ),
                      )),
                    const SizedBox(height: 16),
                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: widget.onClose,
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(AppRadius.full),
                                ),
                                alignment: Alignment.center,
                                child: Text('Close',
                                    style: GoogleFonts.inter(
                                        color: AppColors.textPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: widget.onWrapUp,
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.accentPurple.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(AppRadius.full),
                                ),
                                alignment: Alignment.center,
                                child: Text('Wrap up session',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  const _SheetRow({
    required this.icon, required this.title,
    required this.subtitle, required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, size: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          color: AppColors.textPrimary, fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          color: AppColors.textTertiary, fontSize: 12)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
