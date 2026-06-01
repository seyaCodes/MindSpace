import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/repositories/arc_repository.dart';
import '../../../../data/repositories/reflection_repository.dart';
import '../../../../shared/utils/arc_color.dart';
import '../../data/repositories/history_repository.dart';
import '../../domain/entities/history_arc.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final _arcDetailProvider =
    FutureProvider.family<HistoryArc?, String>((ref, id) async {
  return ref.read(historyRepositoryProvider).getArc(id);
});

final _arcReflectionsProvider =
    FutureProvider.family<List<ReflectionModel>, String>((ref, arcId) async {
  return ref.read(reflectionRepositoryProvider).getReflectionsByArc(arcId);
});

final _arcInsightsProvider =
    FutureProvider.family<List<dynamic>, String>((ref, arcId) async {
  return ref.read(arcRepositoryProvider).getInsights(arcId);
});

// ── Screen ────────────────────────────────────────────────────────────────────

class ArcDetailScreen extends ConsumerWidget {
  final String arcId;

  const ArcDetailScreen({super.key, required this.arcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arcAsync = ref.watch(_arcDetailProvider(arcId));

    return Scaffold(
      backgroundColor: const Color(0xFF0E1547),
      body: arcAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white30),
        ),
        error: (_, __) => const Center(
          child: Text('Could not load arc.',
              style: TextStyle(color: Colors.white54)),
        ),
        data: (arc) => arc == null
            ? const Center(
                child: Text('Arc not found.',
                    style: TextStyle(color: Colors.white54)))
            : _ArcDetailBody(arc: arc),
      ),
    );
  }
}

class _ArcDetailBody extends ConsumerStatefulWidget {
  final HistoryArc arc;

  const _ArcDetailBody({required this.arc});

  @override
  ConsumerState<_ArcDetailBody> createState() => _ArcDetailBodyState();
}

class _ArcDetailBodyState extends ConsumerState<_ArcDetailBody> {
  late HistoryArc _arc;

  @override
  void initState() {
    super.initState();
    _arc = widget.arc;
  }

  bool get _isArchived => _arc.status == 'archived';

  void _showRenameDialog() {
    final controller = TextEditingController(text: _arc.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A2460),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Rename arc',
            style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.dmSans(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Arc name',
            hintStyle: GoogleFonts.dmSans(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(.2)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFA970FF)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.dmSans(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(ctx);
              await ref
                  .read(arcRepositoryProvider)
                  .renameArc(_arc.id, name);
              ref.invalidate(_arcDetailProvider(_arc.id));
            },
            child: Text('Save',
                style: GoogleFonts.dmSans(
                    color: const Color(0xFFA970FF),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A2460),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete arc',
            style: GoogleFonts.dmSans(
                color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text(
          'This will permanently delete "${_arc.name}" and all its sessions. This cannot be undone.',
          style: GoogleFonts.dmSans(color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.dmSans(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(arcRepositoryProvider).deleteArc(_arc.id);
              if (mounted) context.go(AppRoutes.history);
            },
            child: Text('Delete',
                style: GoogleFonts.dmSans(
                    color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleArchive() async {
    if (_isArchived) {
      await ref.read(arcRepositoryProvider).reviveArc(_arc.id);
    } else {
      await ref.read(arcRepositoryProvider).archiveArc(_arc.id);
    }
    ref.invalidate(_arcDetailProvider(_arc.id));
    if (mounted) context.go(AppRoutes.history);
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A2460),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _MenuItem(
                icon: Icons.edit_outlined,
                label: 'Rename arc',
                onTap: () {
                  Navigator.pop(context);
                  _showRenameDialog();
                },
              ),
              _MenuItem(
                icon: _isArchived
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined,
                label: _isArchived ? 'Revive arc' : 'Archive arc',
                onTap: () {
                  Navigator.pop(context);
                  _toggleArchive();
                },
              ),
              _MenuItem(
                icon: Icons.delete_outline_rounded,
                label: 'Delete arc',
                color: Colors.redAccent,
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reflectionsAsync = ref.watch(_arcReflectionsProvider(_arc.id));
    final insightsAsync = ref.watch(_arcInsightsProvider(_arc.id));
    final color = arcColor(_arc.id);

    return CustomScrollView(
      slivers: [
        // ── App Bar ──────────────────────────────────────────────
        SliverAppBar(
          backgroundColor: const Color(0xFF0E1547),
          elevation: 0,
          pinned: false,
          leading: GestureDetector(
            onTap: () => context.canPop() ? context.pop() : context.go(AppRoutes.history),
            child: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text('Threads',
                    style: GoogleFonts.dmSans(
                        color: Colors.white70, fontSize: 15)),
              ],
            ),
          ),
          leadingWidth: 120,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz_rounded,
                  color: Colors.white70),
              onPressed: _showMenu,
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Archived banner ─────────────────────────────
                if (_isArchived) ...[
                  _ArchivedBanner(
                    onRevive: _toggleArchive,
                    onContinue: () {},
                  ),
                  const SizedBox(height: 24),
                ],

                // ── Status badge ────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isArchived
                            ? Colors.white38
                            : const Color(0xFF6EECD4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ARC · ${_arc.status.toUpperCase()}',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Arc name ────────────────────────────────────
                Text(
                  _arc.name,
                  style: GoogleFonts.dmSans(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.05,
                  ),
                ),

                // ── Description from insight ────────────────────
                insightsAsync.maybeWhen(
                  data: (insights) {
                    if (insights.isEmpty) return const SizedBox.shrink();
                    final insight = insights.first as Map<String, dynamic>;
                    final text = insight['how_it_evolved'] as String?;
                    if (text == null || text.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        text,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          color: Colors.white60,
                          height: 1.6,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),

                const SizedBox(height: 20),

                // ── Stats row ───────────────────────────────────
                _StatsRow(arc: _arc),

                const SizedBox(height: 28),

                // ── CTAs: Continue chatting + Open Analysis ─────
                if (!_isArchived) ...[
                  GestureDetector(
                    onTap: () => context.push('${AppRoutes.chat}?arcId=${_arc.id}'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB084FC), Color(0xFF14B8A6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.message, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Continue chatting',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Pick up inside ${_arc.name}',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                GestureDetector(
                  onTap: () => context.push('/arc/${_arc.id}/analysis'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.05),
                      border: Border.all(color: Colors.white.withOpacity(.1)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insights, color: Color(0xFF14B8A6), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Open Analysis',
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'What this arc is teaching you',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward, color: Colors.white54, size: 18),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Sessions header ─────────────────────────────
                Row(
                  children: [
                    Text(
                      'Sessions',
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'most recent first',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: Colors.white38,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),

        // ── Sessions list ─────────────────────────────────────────
        reflectionsAsync.when(
          loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
          error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          data: (sessions) {
            if (sessions.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'No sessions yet.',
                    style: GoogleFonts.dmSans(
                        fontSize: 14, color: Colors.white38),
                  ),
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _SessionCard(
                    session: sessions[i],
                    accentColor: color,
                  ),
                  childCount: sessions.length,
                ),
              ),
            );
          },
        ),

        // ── Bottom spacing ────────────────────────────────────────
        const SliverToBoxAdapter(
          child: SizedBox(height: 120),
        ),
      ],
    );
  }
}

// ── Archived banner ───────────────────────────────────────────────────────────

class _ArchivedBanner extends StatelessWidget {
  final VoidCallback onRevive;
  final VoidCallback onContinue;

  const _ArchivedBanner({required this.onRevive, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.archive_outlined,
                    color: Colors.white54, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This arc has ended.',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'You can revive it to pick the thread back up, or just continue reading — it\'s archived.',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: Colors.white54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onRevive,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA78BFA), Color(0xFF7DD3FC)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Revive arc',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onContinue,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.08),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.white.withOpacity(.12)),
                    ),
                    child: Center(
                      child: Text(
                        'Continue reading',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final HistoryArc arc;

  const _StatsRow({required this.arc});

  String _formatDate(DateTime dt) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    final isArchived = arc.archivedAt != null;
    final spanDays = isArchived
        ? arc.archivedAt!.difference(arc.createdAt).inDays
        : DateTime.now().difference(arc.createdAt).inDays;

    return Row(
      children: [
        _StatChip(
          value: '${arc.sessionCount}',
          label: 'SESSIONS',
        ),
        const SizedBox(width: 16),
        _StatChip(
          value: _formatDate(arc.createdAt),
          label: 'STARTED',
          bold: true,
        ),
        const SizedBox(width: 16),
        if (isArchived)
          _StatChip(
            value: _formatDate(arc.archivedAt!),
            label: 'CLOSED',
            bold: true,
          )
        else
          _StatChip(
            value: '${spanDays}D',
            label: 'SPAN',
            bold: true,
          ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final bool bold;

  const _StatChip({
    required this.value,
    required this.label,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: bold ? 15 : 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white38,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

// ── Session card ──────────────────────────────────────────────────────────────

class _SessionCard extends StatelessWidget {
  final ReflectionModel session;
  final Color accentColor;

  const _SessionCard({required this.session, required this.accentColor});

  String _formatDateTime(DateTime dt) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(dt.year, dt.month, dt.day);
    final currentYear = now.year;
    String dateStr;
    if (sessionDay == today) {
      dateStr = 'TODAY';
    } else if (dt.year != currentYear) {
      dateStr = '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } else {
      dateStr = '${months[dt.month - 1]} ${dt.day}';
    }
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h % 12 == 0 ? 12 : h % 12;
    return '$dateStr · $hour:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final tone = session.sessionTone;

    return GestureDetector(
      onTap: () => context.push('${AppRoutes.sessionDetail}/${session.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDateTime(session.createdAt),
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: Colors.white38,
                letterSpacing: 1.1,
              ),
            ),
            if (session.questionToSitWith.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                session.questionToSitWith,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                if (tone != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: accentColor.withOpacity(.3)),
                    ),
                    child: Text(
                      tone.toUpperCase(),
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Open ›',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: accentColor.withOpacity(.8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Menu item ─────────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(.07)),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: c.withOpacity(.8), size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                color: c,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}