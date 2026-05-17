import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════
// ACTIVITY HEATMAP — GitHub-style intensity grid
// Replaces the broken heatmap in analysis_screen
// Properly contained, drag-to-scroll horizontally, no overflow
// ═══════════════════════════════════════════════════════════

class ActivityHeatmap extends StatelessWidget {
  final List<int> dailyCounts; // 14 weeks × 7 days = 98 entries

  const ActivityHeatmap({super.key, this.dailyCounts = const []});

  @override
  Widget build(BuildContext context) {
    // Mock data if none provided
    final counts = dailyCounts.isEmpty ? _mockData() : dailyCounts;
    const totalWeeks = 14;
    const daysPerWeek = 7;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reflection intensity',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFF5F5F7),
                ),
              ),
              Text(
                'last 14 weeks',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color: const Color(0xFF5A5A60),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // The heatmap row — left labels + scrollable grid
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Y-axis day labels (Mon, Wed, Fri)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _DayLabel('Mon'),
                      const SizedBox(height: 18),
                      _DayLabel('Wed'),
                      const SizedBox(height: 18),
                      _DayLabel('Fri'),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Scrollable grid + month labels
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month labels
                        SizedBox(
                          height: 14,
                          child: Row(
                            children: [
                              _MonthLabel('JAN', offset: 0),
                              _MonthLabel('FEB', offset: 90),
                              _MonthLabel('MAR', offset: 90),
                              _MonthLabel('APR', offset: 90),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),

                        // 7×14 grid of cells
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(totalWeeks, (week) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Column(
                                children: List.generate(daysPerWeek, (day) {
                                  final index = week * daysPerWeek + day;
                                  final count =
                                      index < counts.length ? counts[index] : 0;
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 3),
                                    child: _HeatCell(count: count),
                                  );
                                }),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Footer: drag to scroll + legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.arrow_back,
                      color: Color(0xFF5A5A60), size: 12),
                  const SizedBox(width: 6),
                  Text(
                    'drag to scroll',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: const Color(0xFF5A5A60),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Less',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: const Color(0xFF5A5A60),
                    ),
                  ),
                  const SizedBox(width: 8),
                  for (int level = 0; level <= 4; level++) ...[
                    _HeatCell(count: level == 0 ? 0 : level),
                    if (level < 4) const SizedBox(width: 4),
                  ],
                  const SizedBox(width: 8),
                  Text(
                    'More',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: const Color(0xFF5A5A60),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<int> _mockData() {
    // 98 days of pseudo-random intensity
    final list = <int>[];
    for (int i = 0; i < 98; i++) {
      if (i < 20) {
        list.add((i % 4));
      } else if (i < 50) {
        list.add(((i * 7) % 5));
      } else {
        list.add(((i * 3) % 4) + (i % 7 == 0 ? 1 : 0));
      }
    }
    return list.map((v) => v.clamp(0, 4)).toList();
  }
}

class _HeatCell extends StatelessWidget {
  final int count;
  const _HeatCell({required this.count});

  @override
  Widget build(BuildContext context) {
    Color color;
    Border? border;
    switch (count.clamp(0, 4)) {
      case 0:
        color = Colors.transparent;
        border = Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 0.5,
        );
        break;
      case 1:
        color = const Color(0xFF6C5CE7).withOpacity(0.25);
        break;
      case 2:
        color = const Color(0xFF6C5CE7).withOpacity(0.5);
        break;
      case 3:
        color = const Color(0xFF6C5CE7).withOpacity(0.75);
        break;
      default:
        color = const Color(0xFF8B7FF5);
    }
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        border: border,
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String text;
  const _DayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          color: const Color(0xFF5A5A60),
        ),
      ),
    );
  }
}

class _MonthLabel extends StatelessWidget {
  final String text;
  final double offset;
  const _MonthLabel(this.text, {required this.offset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: offset),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          color: const Color(0xFF9B9BA0),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}