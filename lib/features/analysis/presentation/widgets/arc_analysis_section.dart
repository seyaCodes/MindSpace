import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/utils/arc_color.dart';
import '../../../history/data/models/history_arc_model.dart';
import '../../../history/data/providers/history_providers.dart';

class ArcAnalysisSection extends ConsumerWidget {
  const ArcAnalysisSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arcsAsync = ref.watch(historyActiveArcsProvider);

    return arcsAsync.when(
      data: (arcs) {
        if (arcs.isEmpty) return const SizedBox.shrink();
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
                  '${arcs.length} ${arcs.length == 1 ? 'arc' : 'arcs'}',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...arcs.map((arc) => _ArcCard(arc: arc)),
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

class _ArcCard extends StatelessWidget {
  final HistoryArcModel arc;

  const _ArcCard({required this.arc});

  @override
  Widget build(BuildContext context) {
    final color = arcColor(arc.id);
    final img = arcImageAsset(arc.id);

    return GestureDetector(
      onTap: () => context.push('/arc/${arc.id}/analysis'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(.07)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Arc image
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
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.folder_rounded, color: color, size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Arc info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      arc.name,
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${arc.sessionCount} ${arc.sessionCount == 1 ? 'session' : 'sessions'}',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              // Navigate arrow
              Row(
                children: [
                  Text(
                    'Analysis',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 13, color: color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
