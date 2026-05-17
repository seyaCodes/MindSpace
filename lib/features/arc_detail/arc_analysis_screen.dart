import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';

// ═══════════════════════════════════════════════════════════
// ARC ANALYSIS SCREEN (S7c)
// ═══════════════════════════════════════════════════════════

class _MockAnalysis {
  final String arcName;
  final String leadParagraph;
  final Map<String, int> emotionDistribution;
  final String patternHeadline;
  final String patternBody;
  final String turningPointHeadline;
  final String turningPointBody;

  const _MockAnalysis({
    required this.arcName,
    required this.leadParagraph,
    required this.emotionDistribution,
    required this.patternHeadline,
    required this.patternBody,
    required this.turningPointHeadline,
    required this.turningPointBody,
  });
}

const _mockAnalyses = {
  '1': _MockAnalysis(
    arcName: 'The Job Hunt',
    leadParagraph:
        'Across five sessions, a theme kept surfacing beneath the application anxiety: the fear that being seen — really seen — would reveal something lacking. Not the skill, but the permission to take up space.',
    emotionDistribution: {'Anxious': 54, 'Calm': 22, 'Sad': 14, 'Frustrated': 10},
    patternHeadline: 'You spiral before interviews, not after rejections.',
    patternBody:
        'The anticipation is where the most emotion lives. Once a result arrives — good or bad — you stabilise quickly. The pattern suggests the real fear isn\'t failure; it\'s exposure.',
    turningPointHeadline: 'Session 3 — the pressure shifted.',
    turningPointBody:
        'You named the spiral before it pulled you under. That small act of witness — catching yourself mid-descent — was new. It didn\'t stop the anxiety, but it changed your relationship to it.',
  ),
  '2': _MockAnalysis(
    arcName: 'Family',
    leadParagraph:
        'Three sessions of holding space for a relationship that asks more than it gives. The through-line is distance used as protection — and the quiet grief of that choice.',
    emotionDistribution: {'Sad': 40, 'Frustrated': 35, 'Calm': 25},
    patternHeadline: 'Distance is a strategy, not a failure.',
    patternBody:
        'Each session returned to the question of how much you owe versus how much you can give. The frustration isn\'t with them — it\'s with the impossibility of the math.',
    turningPointHeadline: 'Session 2 — naming the grief.',
    turningPointBody:
        'For the first time, you used the word loss. Not anger, not frustration — loss. That distinction opened something that hadn\'t been accessible before.',
  ),
};

const _defaultAnalysis = _MockAnalysis(
  arcName: 'Arc',
  leadParagraph: 'Analysis is generating. Check back after a few more sessions.',
  emotionDistribution: {'Anxious': 50, 'Calm': 30, 'Sad': 20},
  patternHeadline: 'Patterns will emerge over time.',
  patternBody: 'More sessions will surface clearer patterns.',
  turningPointHeadline: 'Turning points take time.',
  turningPointBody: 'Keep going.',
);

class ArcAnalysisScreen extends StatelessWidget {
  final String arcId;
  const ArcAnalysisScreen({super.key, required this.arcId});

  @override
  Widget build(BuildContext context) {
    final a = _mockAnalyses[arcId] ?? _defaultAnalysis;
    final entries = a.emotionDistribution.entries.toList();

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
                // Back nav
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Row(children: [
                        const Icon(Icons.chevron_left,
                            color: AppColors.textSecondary, size: 22),
                        Text('Arc',
                            style: GoogleFonts.inter(
                                color: AppColors.textSecondary, fontSize: 15)),
                      ]),
                    ),
                  ),
                ),
                // Sub-label
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Text(
                      'ANALYSIS · ${a.arcName.toUpperCase()}',
                      style: GoogleFonts.inter(
                          color: AppColors.textTertiary, fontSize: 11,
                          fontWeight: FontWeight.w500, letterSpacing: 1.0),
                    ),
                  ),
                ),
                // Hero title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'What this arc\n',
                          style: GoogleFonts.inter(
                              fontSize: 36, fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary, height: 1.1),
                        ),
                        TextSpan(
                          text: 'is teaching you.',
                          style: GoogleFonts.inter(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xFFB8A8E8), Color(0xFF8B7FF5)],
                              ).createShader(
                                  const Rect.fromLTWH(0, 0, 400, 70)),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                // Lead paragraph
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Text(
                      a.leadParagraph,
                      style: GoogleFonts.inter(
                          color: AppColors.textSecondary, fontSize: 16,
                          height: 1.6),
                    ),
                  ),
                ),
                // Emotion distribution card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
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
                          Row(children: [
                            Text('Dominant emotional weight',
                                style: GoogleFonts.inter(
                                    color: AppColors.textPrimary, fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            const Spacer(),
                            Text('${a.emotionDistribution.values.reduce((a, b) => a + b) ~/ entries.length} avg',
                                style: GoogleFonts.inter(
                                    color: AppColors.textTertiary, fontSize: 12)),
                          ]),
                          const SizedBox(height: 12),
                          // Gradient bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: SizedBox(
                              height: 8,
                              child: Row(
                                children: entries.map((e) => Flexible(
                                  flex: e.value,
                                  child: Container(color: _emotionColor(e.key)),
                                )).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: entries.map((e) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8, height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _emotionColor(e.key),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text('${e.key} ',
                                    style: GoogleFonts.inter(
                                        color: AppColors.textPrimary, fontSize: 13)),
                                Text('${e.value}%',
                                    style: GoogleFonts.inter(
                                        color: AppColors.textSecondary, fontSize: 13)),
                              ],
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Pattern card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                          Row(children: [
                            Container(
                              width: 6, height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentPurple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('PATTERN',
                                style: GoogleFonts.inter(
                                    color: AppColors.accentPurple, fontSize: 11,
                                    fontWeight: FontWeight.w500, letterSpacing: 1.0)),
                          ]),
                          const SizedBox(height: 8),
                          Text(a.patternHeadline,
                              style: GoogleFonts.inter(
                                  color: AppColors.textPrimary, fontSize: 20,
                                  fontWeight: FontWeight.w700, height: 1.2),
                              maxLines: 2),
                          const SizedBox(height: 8),
                          Text(a.patternBody,
                              style: GoogleFonts.inter(
                                  color: AppColors.textSecondary, fontSize: 14,
                                  height: 1.6)),
                        ],
                      ),
                    ),
                  ),
                ),
                // Turning point card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                          Row(children: [
                            Container(
                              width: 6, height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentGreen,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('TURNING POINT',
                                style: GoogleFonts.inter(
                                    color: AppColors.accentGreen, fontSize: 11,
                                    fontWeight: FontWeight.w500, letterSpacing: 1.0)),
                          ]),
                          const SizedBox(height: 8),
                          Text(a.turningPointHeadline,
                              style: GoogleFonts.inter(
                                  color: AppColors.textPrimary, fontSize: 20,
                                  fontWeight: FontWeight.w700, height: 1.2)),
                          const SizedBox(height: 8),
                          Text(a.turningPointBody,
                              style: GoogleFonts.inter(
                                  color: AppColors.textSecondary, fontSize: 14,
                                  height: 1.6)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _emotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'anxious':    return AppColors.accentPurple;
      case 'calm':       return AppColors.accentGreen;
      case 'sad':        return AppColors.accentBlue;
      case 'frustrated': return AppColors.accentOrange;
      case 'happy':      return AppColors.accentHopeful;
      case 'angry':      return AppColors.accentRed;
      default:           return AppColors.textSecondary;
    }
  }
}
