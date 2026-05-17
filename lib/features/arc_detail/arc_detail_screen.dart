import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app/theme.dart';

class _MockArc {
  final String id;
  final String title;
  final String description;
  final bool isArchived;
  final int sessionCount;
  final String startedLabel;
  final String spanLabel;
  final Color color;

  const _MockArc({
    required this.id, required this.title, required this.description,
    required this.isArchived, required this.sessionCount,
    required this.startedLabel, required this.spanLabel, required this.color,
  });
}

const _mockArcs = {
  '1': _MockArc(
    id: '1', title: 'The Job Hunt',
    description: 'Threads of anxiety, validation and self-worth — surfacing whenever a callback lands or doesn\'t.',
    isArchived: false, sessionCount: 7, startedLabel: 'APR 11', spanLabel: '14D',
    color: AppColors.emotionAnxious,
  ),
  '2': _MockArc(
    id: '2', title: 'Perfectionism',
    description: 'A six-session arc that worked through the cost of "good enough" and the fear underneath the polish.',
    isArchived: true, sessionCount: 6, startedLabel: 'FEB 04', spanLabel: 'MAR 18',
    color: AppColors.emotionCalm,
  ),
};

class _SessionEntry {
  final String title;
  final String dateLabel;
  final String emotion;
  final Color emotionColor;
  const _SessionEntry({required this.title, required this.dateLabel,
      required this.emotion, required this.emotionColor});
}

const _mockSessions = [
  _SessionEntry(title: 'The pressure isn\'t about the job', dateLabel: 'TODAY · APR 25 · 7:30 PM',
      emotion: 'ANXIOUS', emotionColor: AppColors.emotionAnxious),
  _SessionEntry(title: 'Found a small steadiness.', dateLabel: 'APR 25 · 9:15 AM',
      emotion: 'CALM', emotionColor: AppColors.emotionCalm),
  _SessionEntry(title: 'The waiting game', dateLabel: 'APR 22 · 10:30 PM',
      emotion: 'ANXIOUS', emotionColor: AppColors.emotionAnxious),
];

class ArcDetailScreen extends StatelessWidget {
  final String arcId;
  const ArcDetailScreen({super.key, required this.arcId});

  @override
  Widget build(BuildContext context) {
    final arc = _mockArcs[arcId] ?? _mockArcs['1']!;

    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3D2B7A),
              Color(0xFF1A1F5E),
              Color(0xFF0E1340),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              // Header nav
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(children: [
                      const Icon(Icons.chevron_left,
                          color: AppColors.textSecondary, size: 22),
                      Text('Threads', style: GoogleFonts.inter(
                          color: AppColors.textSecondary, fontSize: 15)),
                    ]),
                  ),
                ),
              ),
              // Revive banner (archived only)
              if (arc.isArchived)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.archive_outlined,
                                color: AppColors.textTertiary, size: 16),
                            const SizedBox(width: 8),
                            Text('This arc has ended.',
                                style: GoogleFonts.inter(
                                    color: AppColors.textPrimary, fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(height: 6),
                          Text('You can revive it to pick the thread back up, or just continue reading — it\'s archived.',
                              style: GoogleFonts.inter(
                                  color: AppColors.textSecondary, fontSize: 13,
                                  height: 1.4)),
                          const SizedBox(height: 14),
                          Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: wire to ArcRepo.reviveArc(arcId) later
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.accentPurple, Color(0xFF9B8BF5)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(AppRadius.full),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Revive arc',
                                      style: GoogleFonts.inter(
                                          color: Colors.white, fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppRadius.full),
                                  border: Border.all(color: AppColors.border, width: 0.5),
                                ),
                                alignment: Alignment.center,
                                child: Text('Continue reading',
                                    style: GoogleFonts.inter(
                                        color: AppColors.textPrimary, fontSize: 13,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              // Arc header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: arc.color),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ARC · ${arc.isArchived ? "ARCHIVED" : "ACTIVE"}',
                          style: GoogleFonts.inter(
                              color: arc.isArchived
                                  ? AppColors.emotionCalm
                                  : AppColors.accentPurple,
                              fontSize: 11, fontWeight: FontWeight.w600,
                              letterSpacing: 0.8),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Text(arc.title,
                          style: GoogleFonts.inter(
                              color: AppColors.textPrimary, fontSize: 30,
                              fontWeight: FontWeight.w700, height: 1.1)),
                      const SizedBox(height: 8),
                      Text(arc.description,
                          style: GoogleFonts.inter(
                              color: AppColors.textSecondary, fontSize: 14,
                              height: 1.5)),
                      const SizedBox(height: 16),
                      Row(children: [
                        _StatChip(value: '${arc.sessionCount}', label: 'SESSIONS'),
                        const SizedBox(width: 16),
                        _StatChip(value: arc.startedLabel, label: 'STARTED'),
                        const SizedBox(width: 16),
                        _StatChip(value: arc.spanLabel,
                            label: arc.isArchived ? 'CLOSED' : 'SPAN'),
                      ]),
                    ],
                  ),
                ),
              ),
              // Emotion chart
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _EmotionChartCard(arc: arc),
                ),
              ),
              // Sessions section (active only)
              if (!arc.isArchived) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Row(children: [
                      Text('Sessions',
                          style: GoogleFonts.inter(
                              color: AppColors.textPrimary, fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text('most recent first',
                          style: GoogleFonts.inter(
                              color: AppColors.textTertiary, fontSize: 12)),
                    ]),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(_mockSessions.length, (i) => Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: GestureDetector(
                        onTap: () => context.push('/reflection/${i + 1}'),
                        child: _ArcSessionCard(session: _mockSessions[i]),
                      ),
                    )),
                  ),
                ),
                // Generate analysis CTA
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: GestureDetector(
                      onTap: () => context.push('/arc/${arc.id}/analysis'),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              arc.color.withOpacity(0.8),
                              arc.color.withOpacity(0.5),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        alignment: Alignment.center,
                        child: Text('Generate Arc Analysis →',
                            style: GoogleFonts.inter(
                                color: Colors.white, fontSize: 15,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: '$value ',
            style: GoogleFonts.inter(
                color: AppColors.textPrimary, fontSize: 14,
                fontWeight: FontWeight.w700)),
        TextSpan(text: label,
            style: GoogleFonts.inter(
                color: AppColors.textTertiary, fontSize: 11,
                fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      ]),
    );
  }
}

class _EmotionChartCard extends StatelessWidget {
  final _MockArc arc;
  const _EmotionChartCard({required this.arc});

  @override
  Widget build(BuildContext context) {
    final chartLines = [
      // Anxious (purple)
      LineChartBarData(
        color: AppColors.emotionAnxious,
        barWidth: 2,
        isCurved: true,
        curveSmoothness: 0.35,
        spots: const [
          FlSpot(1, 5), FlSpot(2, 5.5), FlSpot(3, 4),
          FlSpot(4, 3), FlSpot(5, 5),
        ],
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
            radius: 4.5,
            color: AppColors.emotionAnxious,
            strokeWidth: 2,
            strokeColor: const Color(0xFF1A1F5E),
          ),
        ),
      ),
      // Calm (green)
      LineChartBarData(
        color: AppColors.emotionCalm,
        barWidth: 2,
        isCurved: true,
        curveSmoothness: 0.35,
        spots: const [FlSpot(4, 6), FlSpot(5, 6.5)],
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
            radius: 5,
            color: AppColors.emotionCalm,
            strokeWidth: 2,
            strokeColor: const Color(0xFF1A1F5E),
          ),
        ),
      ),
      // Sad (blue)
      LineChartBarData(
        color: AppColors.emotionSad,
        barWidth: 2,
        spots: const [FlSpot(2, 4)],
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
            radius: 4,
            color: AppColors.emotionSad,
            strokeWidth: 2,
            strokeColor: const Color(0xFF1A1F5E),
          ),
        ),
      ),
      // Frustrated (orange)
      LineChartBarData(
        color: AppColors.emotionFrustrated,
        barWidth: 2,
        spots: const [FlSpot(3, 2)],
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
            radius: 5,
            color: AppColors.emotionFrustrated,
            strokeWidth: 2,
            strokeColor: const Color(0xFF1A1F5E),
          ),
        ),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('EMOTION · LAST ${arc.sessionCount} SESSIONS',
                style: GoogleFonts.inter(
                    color: AppColors.textTertiary, fontSize: 11,
                    fontWeight: FontWeight.w600, letterSpacing: 0.5)),
            const Spacer(),
            Text('peaks marked',
                style: GoogleFonts.inter(
                    color: AppColors.textTertiary, fontSize: 11)),
          ]),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: 7,
                minY: 0,
                maxY: 7,
                lineTouchData: const LineTouchData(enabled: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.border.withOpacity(0.3),
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 52,
                      getTitlesWidget: (value, meta) {
                        final labels = {
                          6.0: 'Happy',
                          5.0: 'Calm',
                          4.0: 'Anxious',
                          3.0: 'Sad',
                          2.0: 'Frustr.',
                          1.0: 'Angry',
                          0.0: 'Numb',
                        };
                        final label = labels[value];
                        if (label == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(label,
                              style: GoogleFonts.inter(
                                  color: AppColors.textTertiary, fontSize: 9),
                              textAlign: TextAlign.right),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        final intVal = value.toInt();
                        if (value != intVal.toDouble() || intVal < 1 || intVal > 7) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('S$intVal',
                              style: GoogleFonts.inter(
                                  color: AppColors.textTertiary, fontSize: 9)),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: chartLines,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcSessionCard extends StatelessWidget {
  final _SessionEntry session;
  const _ArcSessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: session.emotionColor.withOpacity(0.4), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: session.emotionColor.withOpacity(0.12),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(session.dateLabel,
              style: GoogleFonts.inter(
                  color: AppColors.textTertiary, fontSize: 10,
                  fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(session.title,
              style: GoogleFonts.inter(
                  color: AppColors.textPrimary, fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(children: [
            Text(session.emotion,
                style: GoogleFonts.inter(
                    color: session.emotionColor, fontSize: 11,
                    fontWeight: FontWeight.w600, letterSpacing: 0.6)),
            const Spacer(),
            Text('Open →',
                style: GoogleFonts.inter(
                    color: AppColors.textTertiary, fontSize: 13)),
          ]),
        ],
      ),
    );
  }
}
