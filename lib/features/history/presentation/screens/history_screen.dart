import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/app_router.dart';
import '../../data/models/history_arc_model.dart';
import '../../data/models/history_reflection_model.dart';
import '../../data/providers/history_providers.dart';

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool _showTimeline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171F5A),
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
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your story chapters',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 28),
                  // Tab toggle — unchanged visually
                  Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.06),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _showTimeline = true),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: _showTimeline
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFFA78BFA),
                                          Color(0xFF7DD3FC),
                                        ],
                                      )
                                    : null,
                              ),
                              child: const Center(
                                child: Text(
                                  'Timeline',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _showTimeline = false),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: !_showTimeline
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFFA78BFA),
                                          Color(0xFF7DD3FC),
                                        ],
                                      )
                                    : null,
                              ),
                              child: const Center(
                                child: Text(
                                  'Arcs',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
            const SizedBox(height: 24),
            Expanded(
              child: _showTimeline
                  ? const _TimelineView()
                  : const _ArcsView(),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Timeline tab
// ---------------------------------------------------------------------------

class _TimelineView extends ConsumerWidget {
  const _TimelineView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(historyTimelineProvider);
    return async.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white54),
      ),
      error: (_, __) => const _EmptyTimelineView(),
      data: (reflections) => reflections.isEmpty
          ? const _EmptyTimelineView()
          : _TimelineList(reflections: reflections),
    );
  }
}

class _TimelineList extends StatelessWidget {
  final List<HistoryReflectionModel> reflections;

  const _TimelineList({required this.reflections});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      itemCount: reflections.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _TimelineTile(reflection: reflections[i]),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final HistoryReflectionModel reflection;

  const _TimelineTile({required this.reflection});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(reflection.createdAt),
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: Colors.white38,
              letterSpacing: 1.1,
            ),
          ),
          if (reflection.title.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              reflection.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ],
          if (reflection.summary.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              reflection.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: Colors.white54,
                height: 1.4,
              ),
            ),
          ],
        ],
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
            Icon(Icons.history, size: 72, color: Colors.white.withOpacity(.4)),
            const SizedBox(height: 16),
            const Text(
              'No reflections yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your completed sessions will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(.7)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Arcs tab
// ---------------------------------------------------------------------------

class _ArcsView extends ConsumerWidget {
  const _ArcsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAsync = ref.watch(historyActiveArcsProvider);
    final archivedAsync = ref.watch(historyArchivedArcsProvider);

    return activeAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white54),
      ),
      error: (_, __) => const _EmptyArcView(),
      data: (active) {
        final archived = archivedAsync.valueOrNull ?? [];
        if (active.isEmpty && archived.isEmpty) return const _EmptyArcView();
        return _ArcsList(active: active, archived: archived);
      },
    );
  }
}

class _ArcsList extends StatelessWidget {
  final List<HistoryArcModel> active;
  final List<HistoryArcModel> archived;

  const _ArcsList({required this.active, required this.archived});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      children: [
        if (active.isNotEmpty) ...[
          _SectionLabel(label: 'ACTIVE'),
          const SizedBox(height: 12),
          ...active.map((arc) => _ArcTile(arc: arc)),
        ],
        if (archived.isNotEmpty) ...[
          if (active.isNotEmpty) const SizedBox(height: 24),
          _SectionLabel(label: 'ARCHIVED'),
          const SizedBox(height: 12),
          ...archived.map((arc) => _ArcTile(arc: arc)),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.white38,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _ArcTile extends StatelessWidget {
  final HistoryArcModel arc;

  const _ArcTile({required this.arc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.arcDetail}/${arc.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.07)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    arc.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
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
            const Icon(Icons.chevron_right_rounded, color: Colors.white24),
          ],
        ),
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
            Icon(Icons.folder_outlined,
                size: 72, color: Colors.white.withOpacity(.4)),
            const SizedBox(height: 16),
            const Text(
              'No arcs yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Arcs will be generated automatically as patterns emerge.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(.7)),
            ),
          ],
        ),
      ),
    );
  }
}
