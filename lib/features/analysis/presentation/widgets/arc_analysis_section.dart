import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/utils/arc_color.dart';
import '../../data/providers/analysis_providers.dart';

class ArcAnalysisSection extends ConsumerWidget {
  const ArcAnalysisSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(arcInsightsProvider);

    return insights.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Arc analyses',
                  style: GoogleFonts.dmSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  '${items.length} ${items.length == 1 ? 'arc' : 'arcs'}',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _ArcAnalysisCard(
                  insight: item as Map<String, dynamic>,
                )),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white30),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _ArcAnalysisCard extends StatelessWidget {
  final Map<String, dynamic> insight;

  const _ArcAnalysisCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    final arcsMap = insight['arcs'] as Map<String, dynamic>?;
    final arcId = arcsMap?['id'] as String? ?? insight['arc_id'] as String? ?? '';
    final arcName = arcsMap?['name'] as String? ?? 'Arc';
    final sessionCount = (insight['session_count_at_generation'] as int?) ?? 0;
    final howItEvolved = insight['how_it_evolved'] as String? ?? '';
    final patternNoticed = insight['pattern_noticed'] as String? ?? '';

    final color = arcId.isNotEmpty ? arcColor(arcId) : const Color(0xFF9B59B6);
    final img = arcId.isNotEmpty ? arcImageAsset(arcId) : 'assets/purple.png';

    final description = howItEvolved.isNotEmpty ? howItEvolved : patternNoticed;

    return GestureDetector(
      onTap: arcId.isNotEmpty
          ? () => context.push('/arc/$arcId/analysis')
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: color.withOpacity(.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        img,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.folder_rounded,
                          color: color,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          arcName,
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        if (description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: Colors.white54,
                                height: 1.4,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Colored accent bar (represents arc progress/intensity)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: Colors.transparent,
                  minHeight: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color.withOpacity(.6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  Text(
                    '$sessionCount ${sessionCount == 1 ? 'SESSION' : 'SESSIONS'}',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white38,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: arcId.isNotEmpty
                        ? () => context.push('/arc/$arcId/analysis')
                        : null,
                    child: Row(
                      children: [
                        Text(
                          'Open analysis',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded,
                            size: 13, color: color),
                      ],
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
