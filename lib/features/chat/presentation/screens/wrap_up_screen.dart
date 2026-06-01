import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/router/app_router.dart';
import '../../../../data/repositories/reflection_repository.dart';
import '../../../../shared/utils/arc_color.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class _WrapUpData {
  final String whatSageHeard;
  final String questionToSitWith;
  final String sharedPerspective;
  final String? arcId;
  final String? arcName;
  final int arcSessionCount;

  const _WrapUpData({
    required this.whatSageHeard,
    required this.questionToSitWith,
    required this.sharedPerspective,
    this.arcId,
    this.arcName,
    this.arcSessionCount = 0,
  });
}

final _wrapUpDataProvider =
    FutureProvider.family<_WrapUpData?, String>((ref, chatId) async {
  final result = await Supabase.instance.client
      .from('reflections')
      .select(
        'id, what_sage_heard, question_to_sit_with, shared_perspective, arc_id, arcs(name, session_count)',
      )
      .eq('chat_id', chatId)
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();

  if (result == null) return null;

  final arcsMap = result['arcs'] as Map<String, dynamic>?;
  return _WrapUpData(
    whatSageHeard: result['what_sage_heard'] as String? ?? '',
    questionToSitWith: result['question_to_sit_with'] as String? ?? '',
    sharedPerspective: result['shared_perspective'] as String? ?? '',
    arcId: result['arc_id'] as String?,
    arcName: arcsMap?['name'] as String?,
    arcSessionCount: (arcsMap?['session_count'] as int?) ?? 0,
  );
});

final _arcSessionsProvider =
    FutureProvider.family<List<ReflectionModel>, String>((ref, arcId) async {
  return ref.read(reflectionRepositoryProvider).getReflectionsByArc(arcId);
});

// ── Screen ────────────────────────────────────────────────────────────────────

class WrapUpScreen extends ConsumerWidget {
  final String chatId;

  const WrapUpScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_wrapUpDataProvider(chatId));

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      body: SafeArea(
        child: async.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white54),
          ),
          error: (_, __) => _Body(data: null, chatId: chatId),
          data: (data) => _Body(data: data, chatId: chatId),
        ),
      ),
    );
  }
}

// ── Body ─────────────────────────────────────────────────────────────────────

class _Body extends ConsumerWidget {
  final _WrapUpData? data;
  final String chatId;

  const _Body({required this.data, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top nav bar ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.go(AppRoutes.home),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white54, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        'Sage',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Header ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SESSION WRAP-UP',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white38,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Where you\n',
                      style: GoogleFonts.dmSans(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    TextSpan(
                      text: 'traveled.',
                      style: GoogleFonts.dmSans(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color:
                            const Color(0xFFA970FF).withOpacity(.65),
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              if (data?.arcName != null) ...[
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _showArcSheet(context, ref, data!),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF6EECD4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Sage thinks this lives near ',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  color: Colors.white54,
                                ),
                              ),
                              TextSpan(
                                text: data!.arcName!,
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: ' . Confirm >',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  color: Colors.white38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 32),

        // ── Reflection cards ─────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: data == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'Reflection is still being processed.\nCheck back in a moment.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          color: Colors.white38,
                          height: 1.6,
                        ),
                      ),
                    ),
                  )
                : _buildCards(data!),
          ),
        ),

        // ── Actions ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: BorderSide(
                        color: Colors.white.withOpacity(.2)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Home',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (data?.arcId != null) {
                      context.push('${AppRoutes.arcDetail}/${data!.arcId}');
                    } else {
                      context.go(AppRoutes.history);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA970FF),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    data?.arcId != null ? 'View Arc' : 'View History',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCards(_WrapUpData d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (d.whatSageHeard.isNotEmpty)
          _Card(
            label: 'WHAT SAGE HEARD',
            content: d.whatSageHeard,
            bg: Colors.white.withOpacity(.06),
            border: Colors.white.withOpacity(.1),
          ),
        if (d.questionToSitWith.isNotEmpty) ...[
          const SizedBox(height: 14),
          _Card(
            label: 'QUESTION TO SIT WITH',
            content: d.questionToSitWith,
            bg: const Color(0xFFA970FF).withOpacity(.08),
            border: const Color(0xFFA970FF).withOpacity(.25),
            bold: true,
          ),
        ],
        if (d.sharedPerspective.isNotEmpty) ...[
          const SizedBox(height: 14),
          _Card(
            label: 'SHARED PERSPECTIVE',
            content: d.sharedPerspective,
            bg: const Color(0xFF6EECD4).withOpacity(.05),
            border: const Color(0xFF6EECD4).withOpacity(.18),
            contentColor: Colors.white.withOpacity(.75),
            italic: true,
          ),
        ],
      ],
    );
  }

  void _showArcSheet(
      BuildContext context, WidgetRef ref, _WrapUpData d) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ArcAssignmentSheet(data: d, ref: ref),
    );
  }
}

// ── Arc assignment bottom sheet ───────────────────────────────────────────────

class _ArcAssignmentSheet extends ConsumerStatefulWidget {
  final _WrapUpData data;
  final WidgetRef ref;

  const _ArcAssignmentSheet({required this.data, required this.ref});

  @override
  ConsumerState<_ArcAssignmentSheet> createState() =>
      _ArcAssignmentSheetState();
}

class _ArcAssignmentSheetState
    extends ConsumerState<_ArcAssignmentSheet> {
  bool _sessionsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final color = d.arcId != null
        ? arcColor(d.arcId!)
        : const Color(0xFF9B59B6);
    final img =
        d.arcId != null ? arcImageAsset(d.arcId!) : 'assets/purple.png';

    final sessionsAsync = d.arcId != null
        ? ref.watch(_arcSessionsProvider(d.arcId!))
        : const AsyncValue<List<ReflectionModel>>.data([]);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A2460),
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                children: [
                  // Arc identity card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: color.withOpacity(.25)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 52,
                          height: 52,
                          child: Image.asset(
                            img,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.folder_rounded,
                              size: 40,
                              color: color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.arcName ?? 'Unknown Arc',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${d.arcSessionCount} ${d.arcSessionCount == 1 ? 'session' : 'sessions'}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'this session',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // "This feels like it belongs to..." option
                  _SheetOption(
                    icon: Icons.auto_awesome_rounded,
                    title: 'This feels like it belongs to…',
                    subtitle: 'Suggest a different arc · still confirmed by ML',
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: Colors.white38),
                    onTap: () {
                      Navigator.pop(context);
                      if (d.arcId != null) {
                        context.push(
                            '${AppRoutes.arcDetail}/${d.arcId}');
                      }
                    },
                  ),

                  const SizedBox(height: 6),

                  // "View past sessions" expandable
                  _SheetOption(
                    icon: Icons.grid_view_rounded,
                    title: 'View past sessions in this arc',
                    subtitle: '${d.arcSessionCount} ${d.arcSessionCount == 1 ? 'session' : 'sessions'} · timeline below',
                    trailing: Icon(
                      _sessionsExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.white38,
                    ),
                    onTap: () => setState(
                        () => _sessionsExpanded = !_sessionsExpanded),
                  ),

                  if (_sessionsExpanded) ...[
                    const SizedBox(height: 8),
                    sessionsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: Colors.white30),
                        ),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (sessions) => Column(
                        children: sessions
                            .map((s) => _MiniSessionRow(session: s))
                            .toList(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: BorderSide(
                            color: Colors.white.withOpacity(.2)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.home);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA78BFA),
                        foregroundColor: Colors.black87,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Wrap up session',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.07)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white54, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white38,
                    ),
                  ),
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

class _MiniSessionRow extends StatelessWidget {
  final ReflectionModel session;

  const _MiniSessionRow({required this.session});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h % 12 == 0 ? 12 : h % 12;
    return '${months[dt.month - 1]} ${dt.day} · $hour:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.questionToSitWith.isNotEmpty
                      ? session.questionToSitWith
                      : session.whatSageHeard,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(session.createdAt),
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 12, color: Colors.white24),
        ],
      ),
    );
  }
}

// ── Shared card widget ────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final String label;
  final String content;
  final Color bg;
  final Color border;
  final Color contentColor;
  final bool bold;
  final bool italic;

  const _Card({
    required this.label,
    required this.content,
    required this.bg,
    required this.border,
    this.contentColor = Colors.white,
    this.bold = false,
    this.italic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white38,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight:
                  bold ? FontWeight.w600 : FontWeight.normal,
              fontStyle:
                  italic ? FontStyle.italic : FontStyle.normal,
              color: contentColor,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}