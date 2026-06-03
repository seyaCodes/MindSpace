import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/app_router.dart';
import '../../../../data/providers/arc_providers.dart';
import '../../../../data/repositories/arc_repository.dart';
import '../../../../shared/utils/arc_color.dart';
import '../../data/models/history_arc_model.dart';
import '../../data/models/history_reflection_model.dart';
import '../../data/providers/history_providers.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool _showTimeline = true;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1547),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'History',
                    style: GoogleFonts.dmSans(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _showTimeline ? 'Your memory vault' : 'Your story chapters',
                    style: GoogleFonts.dmSans(
                        fontSize: 15, color: Colors.white54),
                  ),
                  const SizedBox(height: 20),
                  _TabToggle(
                    showTimeline: _showTimeline,
                    onTimeline: () => setState(() => _showTimeline = true),
                    onArcs: () => setState(() => _showTimeline = false),
                  ),
                  // Search bar — Timeline only
                  if (_showTimeline) ...[
                    const SizedBox(height: 16),
                    _SearchBar(
                      onChanged: (q) => setState(() => _searchQuery = q),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _showTimeline
                  ? _TimelineView(searchQuery: _searchQuery)
                  : const _ArcsView(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search_rounded, color: Colors.white38, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: GoogleFonts.dmSans(
                  fontSize: 14, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search your reflections...',
                hintStyle: GoogleFonts.dmSans(
                    fontSize: 14, color: Colors.white38),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(Icons.tune_rounded,
                  color: Colors.white38, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab toggle ────────────────────────────────────────────────────────────────

class _TabToggle extends StatelessWidget {
  final bool showTimeline;
  final VoidCallback onTimeline;
  final VoidCallback onArcs;

  const _TabToggle({
    required this.showTimeline,
    required this.onTimeline,
    required this.onArcs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TabItem(
            label: 'Timeline',
            icon: Icons.access_time_rounded,
            selected: showTimeline,
            onTap: onTimeline,
          ),
          _TabItem(
            label: 'Arcs',
            icon: Icons.folder_outlined,
            selected: !showTimeline,
            onTap: onArcs,
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: selected
                ? const LinearGradient(
                    colors: [Color(0xFFA78BFA), Color(0xFF7DD3FC)],
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: selected ? Colors.white : Colors.white54),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  color: selected ? Colors.white : Colors.white54,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Timeline ──────────────────────────────────────────────────────────────────

class _TimelineView extends ConsumerWidget {
  final String searchQuery;

  const _TimelineView({required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(historyTimelineProvider);
    return async.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white30),
      ),
      error: (_, __) => const _EmptyTimelineView(),
      data: (reflections) {
        var filtered = reflections;
        if (searchQuery.isNotEmpty) {
          final q = searchQuery.toLowerCase();
          filtered = reflections.where((r) {
            return r.title.toLowerCase().contains(q) ||
                r.summary.toLowerCase().contains(q) ||
                (r.arcName?.toLowerCase().contains(q) ?? false);
          }).toList();
        }
        return filtered.isEmpty
            ? const _EmptyTimelineView()
            : _TimelineList(reflections: filtered);
      },
    );
  }
}

class _TimelineList extends StatelessWidget {
  final List<HistoryReflectionModel> reflections;

  const _TimelineList({required this.reflections});

  List<(DateTime date, List<HistoryReflectionModel> items)> _group(
    List<HistoryReflectionModel> items,
  ) {
    final Map<DateTime, List<HistoryReflectionModel>> map = {};
    for (final r in items) {
      final d = DateTime(r.createdAt.year, r.createdAt.month, r.createdAt.day);
      map.putIfAbsent(d, () => []).add(r);
    }
    final sorted = map.keys.toList()..sort((a, b) => b.compareTo(a));
    return sorted.map((d) => (d, map[d]!)).toList();
  }

  String _monthDay(DateTime d) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    final groups = _group(reflections);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      itemCount: groups.length,
      itemBuilder: (_, gi) {
        final (date, items) = groups[gi];
        String label;
        if (date == today) {
          label =
              'TODAY, ${_monthDay(date)} · ${items.length} ${items.length == 1 ? 'SESSION' : 'SESSIONS'}';
        } else if (date == yesterday) {
          label = 'YESTERDAY, ${_monthDay(date)}';
        } else {
          label = _monthDay(date);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (gi > 0) const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF9B59B6),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white38,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((r) => _TimelineTile(reflection: r)),
          ],
        );
      },
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final HistoryReflectionModel reflection;

  const _TimelineTile({required this.reflection});

  String _time(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h % 12 == 0 ? 12 : h % 12;
    return '$hour:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final hasArc =
        reflection.arcName != null && reflection.arcName!.isNotEmpty;
    final chipColor =
        hasArc ? arcColor(reflection.arcId) : const Color(0xFF555580);

    return GestureDetector(
      onTap: () =>
          context.push('${AppRoutes.sessionDetail}/${reflection.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Row(
                children: [
                  if (hasArc)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: chipColor.withOpacity(.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: chipColor.withOpacity(.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.folder_outlined,
                                size: 11, color: chipColor),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                reflection.arcName!.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: chipColor,
                                  letterSpacing: 0.9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    _time(reflection.createdAt),
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Text(
                reflection.title.isNotEmpty
                    ? reflection.title
                    : reflection.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ),
            if (reflection.summary.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
                child: Text(
                  '"${reflection.summary}"',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: Colors.white54,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B59B6).withOpacity(.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF9B59B6).withOpacity(.22),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded,
                          size: 13, color: Color(0xFF9B59B6)),
                      const SizedBox(width: 5),
                      Text(
                        'View Reflection',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9B59B6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTimelineView extends StatelessWidget {
  const _EmptyTimelineView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded,
                size: 64, color: Colors.white.withOpacity(.2)),
            const SizedBox(height: 16),
            Text(
              'No reflections yet',
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your completed sessions will appear here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                  color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Arcs grid ─────────────────────────────────────────────────────────────────

class _ArcsView extends ConsumerStatefulWidget {
  const _ArcsView();

  @override
  ConsumerState<_ArcsView> createState() => _ArcsViewState();
}

class _ArcsViewState extends ConsumerState<_ArcsView> {
  bool _archivedExpanded = false;
  bool _organizeMode = false;

  Future<void> _confirmDelete(
      BuildContext context, String arcId, String arcName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2456),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete "$arcName"?',
          style: GoogleFonts.dmSans(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This will permanently delete this arc. Your session reflections '
          'will remain in the timeline.',
          style: GoogleFonts.dmSans(
              color: Colors.white54, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: GoogleFonts.dmSans(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: GoogleFonts.dmSans(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(arcRepositoryProvider).deleteArc(arcId);
      ref.invalidate(arcsProvider);
      ref.invalidate(historyActiveArcsProvider);
      ref.invalidate(historyArchivedArcsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeAsync = ref.watch(historyActiveArcsProvider);
    final archivedAsync = ref.watch(historyArchivedArcsProvider);

    return activeAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white30),
      ),
      error: (_, __) => const _EmptyArcView(),
      data: (active) {
        final archived = archivedAsync.valueOrNull ?? [];
        if (active.isEmpty && archived.isEmpty) return const _EmptyArcView();

        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
          children: [
            if (active.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIVE THREADS',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white38,
                          letterSpacing: 1.4,
                        ),
                      ),
                      Text(
                        '${active.length} ongoing ${active.length == 1 ? 'arc' : 'arcs'}',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _organizeMode = !_organizeMode),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: _organizeMode
                            ? Colors.redAccent.withOpacity(.12)
                            : Colors.white.withOpacity(.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _organizeMode
                              ? Colors.redAccent.withOpacity(.3)
                              : Colors.white.withOpacity(.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _organizeMode
                                ? Icons.close_rounded
                                : Icons.grid_view_rounded,
                            size: 14,
                            color: _organizeMode
                                ? Colors.redAccent
                                : Colors.white54,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _organizeMode ? 'Done' : 'Organize',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _organizeMode
                                  ? Colors.redAccent
                                  : Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.85,
                ),
                itemCount: active.length,
                itemBuilder: (_, i) => _ArcGridCell(
                  arc: active[i],
                  organizeMode: _organizeMode,
                  onDelete: () => _confirmDelete(
                      context, active[i].id, active[i].name),
                ),
              ),
            ],
            if (archived.isNotEmpty) ...[
              const SizedBox(height: 28),
              GestureDetector(
                onTap: () => setState(
                    () => _archivedExpanded = !_archivedExpanded),
                child: Row(
                  children: [
                    Icon(Icons.archive_outlined,
                        size: 14, color: Colors.white38),
                    const SizedBox(width: 6),
                    Text(
                      'ARCHIVED CHAPTERS · ${archived.length}',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white38,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _archivedExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.white38,
                    ),
                  ],
                ),
              ),
              if (_archivedExpanded) ...[
                const SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: archived.length,
                  itemBuilder: (_, i) =>
                      _ArcGridCell(arc: archived[i], muted: true),
                ),
              ],
            ],
          ],
        );
      },
    );
  }
}

class _ArcGridCell extends StatelessWidget {
  final HistoryArcModel arc;
  final bool muted;
  final bool organizeMode;
  final VoidCallback? onDelete;

  const _ArcGridCell({
    required this.arc,
    this.muted = false,
    this.organizeMode = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final img = arcImageAsset(arc.id);
    final color = arcColor(arc.id);

    return GestureDetector(
      onTap: organizeMode ? null : () => context.push('${AppRoutes.arcDetail}/${arc.id}'),
      child: Stack(
        children: [
          Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Opacity(
                  opacity: muted ? 0.5 : 1.0,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      img,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.folder_rounded,
                        size: 64,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    arc.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: muted ? Colors.white54 : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${arc.sessionCount} ${arc.sessionCount == 1 ? 'session' : 'sessions'}',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
          if (organizeMode)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyArcView extends StatelessWidget {
  const _EmptyArcView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_rounded,
                size: 64, color: Colors.white.withOpacity(.2)),
            const SizedBox(height: 16),
            Text(
              'No arcs yet',
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Arcs emerge automatically as you reflect.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                  color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}