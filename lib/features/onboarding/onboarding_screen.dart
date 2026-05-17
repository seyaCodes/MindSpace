import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../app/router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _page = 0;

  static const _pages = [
    _OnboardingPage(
      title: 'A quiet space\nfor your thoughts.',
      subtitle: 'MindSpace is where you talk to Sage — an AI that listens without judging, and reflects without advising.',
      emoji: '✦',
    ),
    _OnboardingPage(
      title: 'Sessions become\nstories over time.',
      subtitle: 'After a few conversations, Sage starts noticing patterns. These become Arcs — the chapters of your inner life.',
      emoji: '◎',
    ),
    _OnboardingPage(
      title: 'Your reflections,\nalways yours.',
      subtitle: 'Nothing leaves this app without your permission. This is your private space.',
      emoji: '⬡',
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      setState(() => _page++);
    } else {
      ref.read(onboardingCompleteProvider.notifier).state = true;
      context.go('/auth');
    }
  }

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
                colors: [Color(0xFF1E1548), AppColors.bgPrimary, Color(0xFF0A1020)],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _OrbSymbol(
                    key: ValueKey(_page),
                    symbol: _pages[_page].emoji,
                  ),
                ),
                const SizedBox(height: 48),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Column(
                        key: ValueKey(_page),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _pages[_page].title,
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimary,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _pages[_page].subtitle,
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _page == i ? 24 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _page == i ? AppColors.accentPurple : AppColors.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: _next,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.accentPurple,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _page < _pages.length - 1 ? 'Continue' : 'Get started',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String subtitle;
  final String emoji;
  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.emoji,
  });
}

class _OrbSymbol extends StatelessWidget {
  final String symbol;
  const _OrbSymbol({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accentPurple.withOpacity(0.15),
        border: Border.all(
          color: AppColors.accentPurple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          symbol,
          style: const TextStyle(color: AppColors.accentPurple, fontSize: 36),
        ),
      ),
    );
  }
}