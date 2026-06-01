import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/providers/analysis_providers.dart';

class ReflectionHeatmapCard extends ConsumerWidget {
  const ReflectionHeatmapCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heatmapAsync = ref.watch(heatmapProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: heatmapAsync.when(
        loading: () => const SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator(color: Colors.white30)),
        ),
        error: (_, __) => const SizedBox(height: 120),
        data: (data) => _HeatmapContent(reflections: data),
      ),
    );
  }
}

class _HeatmapContent extends StatelessWidget {
  final List<dynamic> reflections;

  const _HeatmapContent({required this.reflections});

  Map<DateTime, int> _buildDayMap() {
    final map = <DateTime, int>{};
    for (final r in reflections) {
      final dt = DateTime.parse(r['created_at'] as String).toLocal();
      final day = DateTime(dt.year, dt.month, dt.day);
      map[day] = (map[day] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final dayMap = _buildDayMap();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    const weeksToShow = 14;
    const totalDays = weeksToShow * 7;

    // Start from the most recent Sunday
    final startOffset = today.weekday % 7;
    final endDay = today.add(Duration(days: 6 - startOffset));
    final startDay = endDay.subtract(const Duration(days: totalDays - 1));

    // Build week columns
    final weeks = <List<DateTime>>[];
    var cursor = startDay;
    while (!cursor.isAfter(endDay)) {
      final week = <DateTime>[];
      for (int d = 0; d < 7; d++) {
        week.add(cursor.add(Duration(days: d)));
      }
      weeks.add(week);
      cursor = cursor.add(const Duration(days: 7));
    }

    const cellSize = 10.0;
    const gap = 3.0;
    const dayLabelWidth = 28.0;

    // Build month labels
    final monthLabels = <(int weekIndex, String label)>[];
    String? lastMonth;
    for (int wi = 0; wi < weeks.length; wi++) {
      final monthStr = _monthAbbr(weeks[wi][0].month);
      if (monthStr != lastMonth) {
        monthLabels.add((wi, monthStr));
        lastMonth = monthStr;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reflection intensity',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              'last $weeksToShow weeks',
              style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white38),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: (cellSize * 7) + (gap * 6) + 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day labels
              SizedBox(
                width: dayLabelWidth,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ...List.generate(7, (i) {
                      const labels = ['', 'Mon', '', 'Wed', '', 'Fri', ''];
                      return SizedBox(
                        height: cellSize + gap,
                        child: Text(
                          labels[i],
                          style: GoogleFonts.dmSans(
                            fontSize: 9,
                            color: Colors.white38,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              // Grid
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month labels row
                      SizedBox(
                        height: 16,
                        width: weeks.length * (cellSize + gap),
                        child: Stack(
                          children: monthLabels.map((ml) {
                            return Positioned(
                              left: ml.$1 * (cellSize + gap),
                              child: Text(
                                ml.$2,
                                style: GoogleFonts.dmSans(
                                  fontSize: 9,
                                  color: Colors.white38,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // Grid rows
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: weeks.map((week) {
                          return Padding(
                            padding: const EdgeInsets.only(right: gap),
                            child: Column(
                              children: week.map((day) {
                                final count = dayMap[day] ?? 0;
                                final isFuture = day.isAfter(today);
                                return Container(
                                  width: cellSize,
                                  height: cellSize,
                                  margin: const EdgeInsets.only(bottom: gap),
                                  decoration: BoxDecoration(
                                    color: isFuture
                                        ? Colors.transparent
                                        : _cellColor(count),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              '← drag to scroll',
              style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white24),
            ),
            const Spacer(),
            Text(
              'Less',
              style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white38),
            ),
            const SizedBox(width: 4),
            ...[0.1, 0.25, 0.5, 0.85].map(
              (opacity) => Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B59B6).withOpacity(opacity),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'More',
              style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white38),
            ),
          ],
        ),
      ],
    );
  }

  Color _cellColor(int count) {
    if (count == 0) return Colors.white.withOpacity(.06);
    if (count == 1) return const Color(0xFF9B59B6).withOpacity(.35);
    if (count == 2) return const Color(0xFF9B59B6).withOpacity(.65);
    return const Color(0xFF9B59B6);
  }

  String _monthAbbr(int month) {
    const m = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
                'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return m[month - 1];
  }
}
