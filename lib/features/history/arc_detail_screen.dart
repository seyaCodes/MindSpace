import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

// ═══════════════════════════════════════════════════════════
// MOCK DATA — replace with real Riverpod provider later
// ═══════════════════════════════════════════════════════════
class _MockArc {
  final String id;
  final String name;
  final String description;
  final bool isArchived;
  final int sessionCount;
  final String startedDate;
  final String? closedDate;
  final String span;
  final String folderAsset;
  final Color arcColor;

  const _MockArc({
    required this.id,
    required this.name,
    required this.description,
    required this.isArchived,
    required this.sessionCount,
    required this.startedDate,
    this.closedDate,
    required this.span,
    required this.folderAsset,
    required this.arcColor,
  });
}

final _mockActiveArc = _MockArc(
  id: '1',
  name: 'The Job Hunt',
  description:
      'Threads of anxiety, validation and self-worth — surfacing whenever a callback lands or doesn\'t.',
  isArchived: false,
  sessionCount: 5,
  startedDate: 'APR 11',
  span: '14D',
  folderAsset: 'assets/purple.png',
  arcColor: const Color(0xFF6C5CE7),
);

final _mockArchivedArc = _MockArc(
  id: '2',
  name: 'Perfectionism',
  description:
      'A six-session arc that worked through the cost of "good enough" and the fear underneath the polish.',
  isArchived: true,
  sessionCount: 6,
  startedDate: 'FEB 04',
  closedDate: 'MAR 18',
  span: '42D',
  folderAsset: 'assets/teal.png',
  arcColor: const Color(0xFF00C48C),
);

// ═══════════════════════════════════════════════════════════
// EMOTION LINE CHART DATA
// Each entry: session index → emotion level (0.0–1.0 scale)
// 7 emotions on Y axis
// ═══════════════════════════════════════════════════════════
const _emotionLabels = [
  'Happy',
  'Calm',
  'Anxious',
  'Sad',
  'Frustr.',
  'Angry',
  'Numb',
];

const _emotionColors = [
  Color(0xFFA8E063), // Happy - yellow green
  Color(0xFF00C48C), // Calm - green
  Color(0xFF6C5CE7), // Anxious - purple
  Color(0xFF5B8DEF), // Sad - blue
  Color(0xFFF39C12), // Frustrated - orange
  Color(0xFFE74C3C), // Angry - red
  Color(0xFF9B9BA0), // Numb - grey
];

// Active arc: 7 sessions, Anxious line is dominant
final _activeChartLines = [
  // Anxious line — main story
  _ChartLine(
    emotionIndex: 2,
    spots: const [
      FlSpot(1, 0.7),
      FlSpot(2, 0.5),
      FlSpot(3, 0.6),
      FlSpot(4, 0.3),
      FlSpot(5, 0.55),
      FlSpot(6, 0.65),
      FlSpot(7, 0.6),
    ],
  ),
  // Calm line
  _ChartLine(
    emotionIndex: 1,
    spots: const [
      FlSpot(1, 0.3),
      FlSpot(3, 0.4),
      FlSpot(5, 0.6),
      FlSpot(7, 0.7),
    ],
  ),
  // Sad line
  _ChartLine(
    emotionIndex: 3,
    spots: const [
      FlSpot(2, 0.4),
      FlSpot(4, 0.5),
      FlSpot(6, 0.3),
    ],
  ),
  // Frustrated — peak at S4
  _ChartLine(
    emotionIndex: 4,
    spots: const [
      FlSpot(3, 0.2),
      FlSpot(4, 0.6),
      FlSpot(5, 0.2),
    ],
  ),
];

// Archived arc: 6 sessions — Perfectionism journey
final _archivedChartLines = [
  // Anxious line
  _ChartLine(
    emotionIndex: 2,
    spots: const [
      FlSpot(1, 0.6),
      FlSpot(2, 0.5),
      FlSpot(3, 0.65),
      FlSpot(4, 0.4),
      FlSpot(5, 0.2),
      FlSpot(6, 0.2),
    ],
  ),
  // Calm — rises
  _ChartLine(
    emotionIndex: 1,
    spots: const [
      FlSpot(1, 0.2),
      FlSpot(3, 0.3),
      FlSpot(5, 0.7),
      FlSpot(6, 0.75),
    ],
  ),
  // Frustrated — peaks at S3
  _ChartLine(
    emotionIndex: 4,
    spots: const [
      FlSpot(2, 0.3),
      FlSpot(3, 0.55),
      FlSpot(4, 0.25),
    ],
  ),
  // Sad
  _ChartLine(
    emotionIndex: 3,
    spots: const [
      FlSpot(1, 0.3),
      FlSpot(2, 0.45),
      FlSpot(4, 0.35),
    ],
  ),
];

class _ChartLine {
  final int emotionIndex;
  final List<FlSpot> spots;
  const _ChartLine({required this.emotionIndex, required this.spots});
}

// ═══════════════════════════════════════════════════════════
// ARC DETAIL SCREEN
// ═══════════════════════════════════════════════════════════
class ArcDetailScreen extends StatelessWidget {
  final String arcId;

  const ArcDetailScreen({super.key, required this.arcId});

  @override
  Widget build(BuildContext context) {
    // Pick mock arc based on ID — replace with provider later
    final arc = arcId == '2' ? _mockArchivedArc : _mockActiveArc;
    final chartLines =
        arc.isArchived ? _archivedChartLines : _activeChartLines;
    final sessionCount = arc.isArchived ? 6 : 7;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D1B69), Color(0xFF0D0D2B)],
            stops: [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Scrollable content
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
                children: [
                  const SizedBox(height: 8),

                  // Back button
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        const Icon(Icons.chevron_left,
                            color: Color(0xFF9B9BA0), size: 22),
                        const SizedBox(width: 2),
                        Text(
                          'Threads',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xFF9B9BA0),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Archived banner — only shows for archived arcs
                  if (arc.isArchived) ...[
                    _ArchivedBanner(),
                    const SizedBox(height: 20),
                  ],

                  // ARC · ACTIVE / ARCHIVED label
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: arc.arcColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        arc.isArchived ? 'ARC · ARCHIVED' : 'ARC · ACTIVE',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9B9BA0),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Arc name
                  Text(
                    arc.name,
                    style: GoogleFonts.inter(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF5F5F7),
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    arc.description,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF9B9BA0),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats row
                  _StatsRow(arc: arc),

                  const SizedBox(height: 24),

                  // Emotion line chart card
                  _EmotionChartCard(
                    lines: chartLines,
                    sessionCount: sessionCount,
                  ),

                  const SizedBox(height: 32),

                  // Sessions header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sessions',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF5F5F7),
                        ),
                      ),
                      Text(
                        arc.isArchived
                            ? 'read-only'
                            : 'most recent first',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          color: const Color(0xFF5A5A60),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Session cards
                  _SessionCard(
                    date: 'TODAY · APR 25 · 7:30 PM',
                    title: 'The pressure isn\'t about the job',
                    body:
                        'Realized the fear is about being seen as not enough — not the role itself.',
                    emotion: 'ANXIOUS',
                    emotionColor: const Color(0xFF6C5CE7),
                    isReadOnly: arc.isArchived,
                  ),
                  const SizedBox(height: 12),
                  _SessionCard(
                    date: 'APR 22 · 10:30 PM',
                    title: 'Found a small steadiness.',
                    body:
                        'Something shifted after writing it out. Less urgency, more ground.',
                    emotion: 'CALM',
                    emotionColor: const Color(0xFF00C48C),
                    isReadOnly: arc.isArchived,
                  ),
                ],
              ),

              // Sticky bottom bar — only for active arcs
              if (!arc.isArchived)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _ContinueArcBar(arcId: arc.id),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ARCHIVED BANNER
// ═══════════════════════════════════════════════════════════
class _ArchivedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.archive_outlined,
                  color: Color(0xFF9B9BA0), size: 16),
              const SizedBox(width: 8),
              Text(
                'This arc has ended.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF5F5F7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'You can revive it to pick the thread back up, or just continue reading — it\'s archived.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF9B9BA0),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Revive arc — gradient button
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFF8B7FF5)],
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Center(
                    child: Text(
                      'Revive arc',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Continue reading — outline button
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Continue reading',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFFF5F5F7),
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

// ═══════════════════════════════════════════════════════════
// STATS ROW
// ═══════════════════════════════════════════════════════════
class _StatsRow extends StatelessWidget {
  final _MockArc arc;
  const _StatsRow({required this.arc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(
          value: '${arc.sessionCount}',
          label: 'SESSIONS',
        ),
        const SizedBox(width: 20),
        _StatItem(
          value: arc.startedDate,
          label: 'STARTED',
        ),
        if (arc.closedDate != null) ...[
          const SizedBox(width: 20),
          _StatItem(
            value: arc.closedDate!,
            label: 'CLOSED',
            highlight: true,
          ),
        ] else ...[
          const SizedBox(width: 20),
          _StatItem(
            value: arc.span,
            label: 'SPAN',
          ),
        ],
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool highlight;
  const _StatItem({
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: highlight
                ? const Color(0xFFF5F5F7)
                : const Color(0xFF9B9BA0),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: const Color(0xFF5A5A60),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// EMOTION LINE CHART CARD
// ═══════════════════════════════════════════════════════════
class _EmotionChartCard extends StatelessWidget {
  final List<_ChartLine> lines;
  final int sessionCount;

  const _EmotionChartCard({
    required this.lines,
    required this.sessionCount,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EMOTION · LAST $sessionCount SESSIONS',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9B9BA0),
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                'peaks marked',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: const Color(0xFF5A5A60),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: Row(
              children: [
                // Y-axis emotion labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _emotionLabels.map((label) {
                    final index = _emotionLabels.indexOf(label);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _emotionColors[index],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          label,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: const Color(0xFF9B9BA0),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(width: 12),
                // Chart
                Expanded(
                  child: LineChart(
                    LineChartData(
                      minX: 1,
                      maxX: sessionCount.toDouble(),
                      minY: 0,
                      maxY: 1,
                      clipData: const FlClipData.all(),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1 / 6,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white.withOpacity(0.06),
                          strokeWidth: 0.5,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                'S${value.toInt()}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: const Color(0xFF5A5A60),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineBarsData: lines.map((line) {
                        final color = _emotionColors[line.emotionIndex];
                        return LineChartBarData(
                          spots: line.spots,
                          isCurved: true,
                          curveSmoothness: 0.4,
                          color: color,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, index) =>
                                FlDotCirclePainter(
                              radius: 4,
                              color: color,
                              strokeWidth: 0,
                              strokeColor: Colors.transparent,
                            ),
                          ),
                          belowBarData: BarAreaData(show: false),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SESSION CARD
// ═══════════════════════════════════════════════════════════
class _SessionCard extends StatelessWidget {
  final String date;
  final String title;
  final String body;
  final String emotion;
  final Color emotionColor;
  final bool isReadOnly;

  const _SessionCard({
    required this.date,
    required this.title,
    required this.body,
    required this.emotion,
    required this.emotionColor,
    required this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: const Color(0xFF5A5A60),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF5F5F7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF9B9BA0),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: emotionColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  emotion,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: emotionColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              if (!isReadOnly)
                Text(
                  'Open →',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF9B9BA0),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// CONTINUE ARC STICKY BOTTOM BAR (active arcs only)
// ═══════════════════════════════════════════════════════════
class _ContinueArcBar extends StatelessWidget {
  final String arcId;
  const _ContinueArcBar({required this.arcId});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0D0D2B).withOpacity(0.0),
            const Color(0xFF0D0D2B),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () => context.push('/chat?arcId=$arcId'),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFF8B7FF5)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              'Continue this Arc →',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}