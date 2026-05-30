import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/providers/arc_providers.dart';
import '../../../../data/providers/reflection_providers.dart';
import '../../../../data/repositories/reflection_repository.dart';
import '../../data/repositories/history_repository.dart';
import '../../domain/entities/history_arc.dart';

class ArcDetailScreen extends ConsumerWidget {
  final String arcId;

  const ArcDetailScreen({super.key, required this.arcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arcAsync = ref.watch(_arcDetailProvider(arcId));
    final reflectionsAsync = ref.watch(reflectionsByArcProvider(arcId));
    final insightsAsync = ref.watch(arcInsightsByArcProvider(arcId));

    return Scaffold(
      backgroundColor: const Color(0xFF171F5A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: arcAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text(
            'Could not load arc.',
            style: TextStyle(color: Colors.white54),
          ),
        ),
        data: (arc) => arc == null
            ? const Center(
                child: Text(
                  'Arc not found.',
                  style: TextStyle(color: Colors.white54),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ArcHeader(arc: arc),
                    const SizedBox(height: 32),
                    _ReflectionsSection(async: reflectionsAsync),
                    const SizedBox(height: 32),
                    _InsightsSection(async: insightsAsync),
                  ],
                ),
              ),
      ),
    );
  }
}

final _arcDetailProvider =
    FutureProvider.family<HistoryArc?, String>((ref, id) async {
  return ref.read(historyRepositoryProvider).getArc(id);
});

class _ArcHeader extends StatelessWidget {
  final HistoryArc arc;

  const _ArcHeader({required this.arc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          arc.name,
          style: GoogleFonts.dmSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                arc.status.toUpperCase(),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white60,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${arc.sessionCount} sessions',
              style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white38),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReflectionsSection extends StatelessWidget {
  final AsyncValue<List<ReflectionModel>> async;

  const _ReflectionsSection({required this.async});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SESSIONS',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white38,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
          data: (reflections) => reflections.isEmpty
              ? Text(
                  'No sessions yet.',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Colors.white38,
                  ),
                )
              : Column(
                  children: reflections
                      .map((r) => _ReflectionTile(reflection: r))
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class _ReflectionTile extends StatelessWidget {
  final ReflectionModel reflection;

  const _ReflectionTile({required this.reflection});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(14),
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
          if (reflection.questionToSitWith.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              reflection.questionToSitWith,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: Colors.white,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _InsightsSection extends StatelessWidget {
  final AsyncValue<List<dynamic>> async;

  const _InsightsSection({required this.async});

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (insights) {
        if (insights.isEmpty) return const SizedBox.shrink();
        final insight = insights.first as Map<String, dynamic>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INSIGHT',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white38,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFA970FF).withOpacity(.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFA970FF).withOpacity(.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((insight['pattern_noticed'] as String?)?.isNotEmpty ==
                      true) ...[
                    Text(
                      'Pattern noticed',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: Colors.white38,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insight['pattern_noticed'] as String,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if ((insight['how_it_evolved'] as String?)?.isNotEmpty ==
                      true) ...[
                    Text(
                      'How it evolved',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: Colors.white38,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insight['how_it_evolved'] as String,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
