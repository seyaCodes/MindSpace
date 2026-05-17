import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import 'widgets/activity_heatmap.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1340),
      body: Stack(
        children: [
          Container(
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
          ),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Analysis',
                            style: GoogleFonts.inter(
                                color: AppColors.textPrimary, fontSize: 36,
                                fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                        const SizedBox(height: 4),
                        Text('Patterns across all of your arcs.',
                            style: GoogleFonts.inter(
                                color: AppColors.textSecondary, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                // Stats row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Row(
                      children: [
                        _StatCard(value: '42', label: 'SESSIONS'),
                        const SizedBox(width: 10),
                        _StatCard(value: '4', label: 'ACTIVE ARCS'),
                        const SizedBox(width: 10),
                        _StatCard(value: '17', label: 'DAYS STREAK'),
                      ],
                    ),
                  ),
                ),
                // Heatmap
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: const ActivityHeatmap(),
                  ),
                ),
                // Arc analyses section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                    child: Row(
                      children: [
                        Text('Arc analyses',
                            style: GoogleFonts.inter(
                                color: AppColors.textPrimary, fontSize: 22,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text('4 arcs',
                            style: GoogleFonts.inter(
                                color: AppColors.textTertiary, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    GestureDetector(
                      onTap: () => context.push('/arc/1/analysis'),
                      child: _ArcPreviewCard(
                        title: 'The Job Hunt',
                        subtitle: 'Anxiety about being seen, slowly becoming steadiness.',
                        sessions: 5,
                        dominantEmotion: 'Anxious',
                        emotionColor: AppColors.accentPurple,
                        distribution: const {'Anxious': 54, 'Calm': 22, 'Sad': 14, 'Frustrated': 10},
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/arc/2/analysis'),
                      child: _ArcPreviewCard(
                        title: 'Family Boundaries',
                        subtitle: 'Holding space without absorbing — a chapter on distance.',
                        sessions: 3,
                        dominantEmotion: 'Sad',
                        emotionColor: AppColors.accentBlue,
                        distribution: const {'Sad': 40, 'Frustrated': 35, 'Calm': 25},
                      ),
                    ),
                    const SizedBox(height: 120),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary, fontSize: 26,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.inter(
                    color: AppColors.textTertiary, fontSize: 10,
                    fontWeight: FontWeight.w600, letterSpacing: 0.8)),
          ],
        ),
      ),
    );
  }
}

class _ArcPreviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int sessions;
  final String dominantEmotion;
  final Color emotionColor;
  final Map<String, int> distribution;

  const _ArcPreviewCard({
    required this.title,
    required this.subtitle,
    required this.sessions,
    required this.dominantEmotion,
    required this.emotionColor,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accentPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.folder_outlined,
                      color: AppColors.accentPurple, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: GoogleFonts.inter(
                              color: AppColors.textPrimary, fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      Text(subtitle,
                          style: GoogleFonts.inter(
                              color: AppColors.textSecondary, fontSize: 12,
                              height: 1.4),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Distribution bar
            _DistributionBar(distribution: distribution),
            const SizedBox(height: 8),
            // Emotion labels
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: distribution.entries.map((e) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 7, height: 7,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _emotionColor(e.key))),
                  const SizedBox(width: 4),
                  Text('${e.key} ${e.value}%',
                      style: GoogleFonts.inter(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              )).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('$sessions SESSIONS · DOMINANT $dominantEmotion'.toUpperCase(),
                    style: GoogleFonts.inter(
                        color: AppColors.textTertiary, fontSize: 10,
                        fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const Spacer(),
                Text('Open analysis →',
                    style: GoogleFonts.inter(
                        color: AppColors.accentPurple, fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _emotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'anxious': return AppColors.accentPurple;
      case 'calm': return AppColors.accentGreen;
      case 'sad': return AppColors.accentBlue;
      case 'frustrated': return AppColors.accentOrange;
      case 'hopeful': return AppColors.accentHopeful;
      default: return AppColors.textSecondary;
    }
  }
}

class _DistributionBar extends StatelessWidget {
  final Map<String, int> distribution;
  const _DistributionBar({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final colors = distribution.keys.map(_emotionColor).toList();
    final values = distribution.values.toList();
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 6,
        child: Row(
          children: List.generate(values.length, (i) => Flexible(
            flex: values[i],
            child: Container(color: colors[i]),
          )),
        ),
      ),
    );
  }

  Color _emotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'anxious': return AppColors.accentPurple;
      case 'calm': return AppColors.accentGreen;
      case 'sad': return AppColors.accentBlue;
      case 'frustrated': return AppColors.accentOrange;
      default: return AppColors.textSecondary;
    }
  }
}
