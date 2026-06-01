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
    final turningPoint = insight['turning_point'] as String?;
    final turningPointContext = insight['turning_point_context'] as String?
        ?? insight['turning_point_description'] as String?;

    final spanDays = arc.archivedAt != null
        ? arc.archivedAt!.difference(arc.createdAt).inDays
        : DateTime.now().difference(arc.createdAt).inDays;
    final weeksSpan = spanDays / 7;
    final frequency = weeksSpan > 0
        ? (arc.sessionCount / weeksSpan).toStringAsFixed(1)
        : '—';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Inline stats row ─────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _StatBox(
                label: 'SESSIONS',
                value: '${arc.sessionCount}',
                sub: 'over time',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatBox(
                label: 'SPAN',
                value: '$spanDays days',
                sub: arc.archivedAt != null ? 'closed' : 'active',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatBox(
                label: 'FREQUENCY',
                value: '${frequency}/wk',
                sub: 'sessions',
              ),
            ),
          ],
        ),

        // ── How it evolved ───────────────────────────────────────
        if (howItEvolved.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'Across ${arc.sessionCount} ${arc.sessionCount == 1 ? 'session' : 'sessions'} over $spanDays days, $howItEvolved',
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: Colors.white60,
              height: 1.65,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],

        // ── Pattern card ─────────────────────────────────────────
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

        // ── Turning point ────────────────────────────────────────
        if (turningPoint != null && turningPoint.isNotEmpty) ...[
          const SizedBox(height: 14),
          _InsightCard(
            label: 'TURNING POINT',
            labelColor: const Color(0xFF6EECD4),
            content: '"$turningPoint"',
            subContent: turningPointContext,
            borderColor: const Color(0xFF6EECD4).withOpacity(.25),
            bgColor: const Color(0xFF6EECD4).withOpacity(.05),
            italic: true,
          ),
        ],
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
  final String? subContent;
  final bool italic;

  const _InsightCard({
    required this.label,
    required this.labelColor,
    required this.content,
    required this.borderColor,
    required this.bgColor,
    this.subContent,
    this.italic = false,
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
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          if (subContent != null && subContent!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subContent!,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: Colors.white54,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _StatBox({
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.white38,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              sub,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: Colors.white38,
              ),
            ),
          ],
        ),
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
