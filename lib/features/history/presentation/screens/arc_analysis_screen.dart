import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/repositories/arc_repository.dart';
import '../../../../shared/utils/arc_color.dart';
import '../../data/repositories/history_repository.dart';
import '../../domain/entities/history_arc.dart';

final _arcAnalysisArcProvider =
    FutureProvider.family<HistoryArc?, String>((ref, id) async {
  return ref.read(historyRepositoryProvider).getArc(id);
});

final _arcAnalysisInsightsProvider =
    FutureProvider.family<List<dynamic>, String>((ref, arcId) async {
  return ref.read(arcRepositoryProvider).getInsights(arcId);
});

class ArcAnalysisScreen extends ConsumerWidget {
  final String arcId;

  const ArcAnalysisScreen({super.key, required this.arcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arcAsync = ref.watch(_arcAnalysisArcProvider(arcId));
    final insightsAsync = ref.watch(_arcAnalysisInsightsProvider(arcId));

    return Scaffold(
      backgroundColor: const Color(0xFF0E1547),
      body: SafeArea(
        child: arcAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white30),
          ),
          error: (_, __) => const Center(
            child: Text('Could not load analysis.',
                style: TextStyle(color: Colors.white54)),
          ),
          data: (arc) => arc == null
              ? const Center(
                  child: Text('Arc not found.',
                      style: TextStyle(color: Colors.white54)))
              : _AnalysisBody(arc: arc, insightsAsync: insightsAsync),
        ),
      ),
    );
  }
}

class _AnalysisBody extends StatelessWidget {
  final HistoryArc arc;
  final AsyncValue<List<dynamic>> insightsAsync;

  const _AnalysisBody({required this.arc, required this.insightsAsync});

  @override
  Widget build(BuildContext context) {
    final color = arcColor(arc.id);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: const Color(0xFF0E1547),
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text('Arc',
                    style: GoogleFonts.dmSans(
                        color: Colors.white70, fontSize: 15)),
              ],
            ),
          ),
          leadingWidth: 100,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Eyebrow ─────────────────────────────────────
                Text(
                  'ANALYSIS · ${arc.name.toUpperCase()}',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white38,
                    letterSpacing: 1.4,
                  ),
                ),

                const SizedBox(height: 16),

                // ── Hero title ──────────────────────────────────
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'What this arc\n',
                        style: GoogleFonts.dmSans(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      TextSpan(
                        text: 'is teaching you',
                        style: GoogleFonts.dmSans(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: color.withOpacity(.7),
                          height: 1.1,
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: GoogleFonts.dmSans(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.white38,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                insightsAsync.when(
                  loading: () => const Center(
                    child:
                        CircularProgressIndicator(color: Colors.white30),
                  ),
                  error: (_, __) => _NoInsightsCard(sessionCount: arc.sessionCount),
                  data: (insights) {
                    if (insights.isEmpty) {
                      return _NoInsightsCard(sessionCount: arc.sessionCount);
                    }
                    final insight =
                        insights.first as Map<String, dynamic>;
                    return _InsightContent(
                        insight: insight, color: color, arc: arc);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightContent extends StatelessWidget {
  final Map<String, dynamic> insight;
  final Color color;
  final HistoryArc arc;

  const _InsightContent({
    required this.insight,
    required this.color,
    required this.arc,
  });

  @override
  Widget build(BuildContext context) {
    final howItEvolved = insight['how_it_evolved'] as String? ?? '';
    final patternNoticed = insight['pattern_noticed'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Sessions context ─────────────────────────────────────
        Text(
          'Across ${arc.sessionCount} ${arc.sessionCount == 1 ? 'session' : 'sessions'} over ${DateTime.now().difference(arc.createdAt).inDays} days, here\'s what emerged:',
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: Colors.white60,
            height: 1.65,
            fontStyle: FontStyle.italic,
          ),
        ),

        if (howItEvolved.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            howItEvolved,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: Colors.white,
              height: 1.7,
            ),
          ),
        ],

        if (patternNoticed.isNotEmpty) ...[
          const SizedBox(height: 20),
          _InsightCard(
            label: 'PATTERN',
            labelColor: color,
            content: patternNoticed,
            borderColor: color.withOpacity(.3),
            bgColor: color.withOpacity(.06),
          ),
        ],

        const SizedBox(height: 28),
        _SessionsOverview(arc: arc, color: color),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String content;
  final Color borderColor;
  final Color bgColor;

  const _InsightCard({
    required this.label,
    required this.labelColor,
    required this.content,
    required this.borderColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: labelColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: labelColor,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionsOverview extends StatelessWidget {
  final HistoryArc arc;
  final Color color;

  const _SessionsOverview({required this.arc, required this.color});

  @override
  Widget build(BuildContext context) {
    final spanDays = arc.archivedAt != null
        ? arc.archivedAt!.difference(arc.createdAt).inDays
        : DateTime.now().difference(arc.createdAt).inDays;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ARC OVERVIEW',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white38,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          _OverviewRow(label: 'Sessions', value: '${arc.sessionCount}'),
          const SizedBox(height: 8),
          _OverviewRow(
            label: 'Started',
            value: _formatDate(arc.createdAt),
          ),
          if (arc.archivedAt != null) ...[
            const SizedBox(height: 8),
            _OverviewRow(
                label: 'Closed', value: _formatDate(arc.archivedAt!)),
          ],
          const SizedBox(height: 8),
          _OverviewRow(label: 'Span', value: '${spanDays} days'),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

class _OverviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white38),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _NoInsightsCard extends StatelessWidget {
  final int sessionCount;

  const _NoInsightsCard({required this.sessionCount});

  @override
  Widget build(BuildContext context) {
    final needed = (3 - sessionCount).clamp(0, 3);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome_rounded,
              size: 32, color: Colors.white.withOpacity(.3)),
          const SizedBox(height: 12),
          Text(
            needed > 0
                ? '$needed more ${needed == 1 ? 'session' : 'sessions'} until your first arc analysis'
                : 'Analysis is being generated…',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: Colors.white54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
