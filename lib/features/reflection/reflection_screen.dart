import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';

class ReflectionScreen extends StatelessWidget {
  final String reflectionId;
  const ReflectionScreen({super.key, required this.reflectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E1548), AppColors.bgPrimary],
                stops: [0.0, 0.5],
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/'),
                          child: Row(children: [
                            const Icon(Icons.chevron_left,
                                color: AppColors.textSecondary, size: 22),
                            Text('Done', style: GoogleFonts.inter(
                                color: AppColors.textSecondary, fontSize: 15)),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SESSION REFLECTION',
                            style: GoogleFonts.inter(
                                color: AppColors.textTertiary, fontSize: 11,
                                fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                        const SizedBox(height: 8),
                        Text('What Sage held for you.',
                            style: GoogleFonts.inter(
                                color: AppColors.textPrimary, fontSize: 26,
                                fontWeight: FontWeight.w700, height: 1.2)),
                        const SizedBox(height: 24),
                        // Spirit orb
                        Center(
                          child: Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentPurple.withOpacity(0.15),
                              border: Border.all(
                                  color: AppColors.accentPurple.withOpacity(0.3),
                                  width: 1.5),
                              boxShadow: [BoxShadow(
                                  color: AppColors.accentPurple.withOpacity(0.2),
                                  blurRadius: 20, spreadRadius: 2)],
                            ),
                            child: const Center(
                              child: Text('✦', style: TextStyle(
                                  color: AppColors.accentPurple, fontSize: 30)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text('Anxious',
                              style: GoogleFonts.inter(
                                  color: AppColors.accentPurple, fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _ReflectionSection(
                      label: 'WHAT SAGE HEARD',
                      content: 'The pressure isn\'t about the job itself — it\'s about the fear of being seen as not enough.',
                    ),
                    _ReflectionSection(
                      label: 'QUESTION TO SIT WITH',
                      content: 'What would it feel like to show up without needing to prove anything?',
                    ),
                    _ReflectionSection(
                      label: 'SHARED PERSPECTIVE',
                      content: 'Many people find that the anxiety before evaluation is louder than the evaluation itself.',
                    ),
                    _ReflectionSection(
                      label: 'MOMENT OF CLARITY',
                      content: 'The fear has a shape now — being seen as not enough. Naming it out loud changed something.',
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accentPurple.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(
                              color: AppColors.accentPurple.withOpacity(0.2),
                              width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('THE JOB HUNT',
                                style: GoogleFonts.inter(
                                    color: AppColors.accentPurple, fontSize: 10,
                                    fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                            const SizedBox(height: 6),
                            Text('Arc updated · session added',
                                style: GoogleFonts.inter(
                                    color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
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

class _ReflectionSection extends StatelessWidget {
  final String label;
  final String content;
  const _ReflectionSection({required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
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
            Text(label,
                style: GoogleFonts.inter(
                    color: AppColors.textTertiary, fontSize: 10,
                    fontWeight: FontWeight.w600, letterSpacing: 1.0)),
            const SizedBox(height: 10),
            Text(content,
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary, fontSize: 15, height: 1.6)),
          ],
        ),
      ),
    );
  }
}
