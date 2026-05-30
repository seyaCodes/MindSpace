import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/router/app_router.dart';
import 'package:mind_space/shared/widgets/app_background.dart';
import 'package:mind_space/shared/widgets/cta_button.dart';
import '../../data/repositories/profile_repository.dart';
import 'widgets/onboarding_page_one.dart';
import 'widgets/onboarding_page_two.dart';
import 'widgets/onboarding_page_three.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _loading = false;

  Future<void> _onContinue() async {
    if (_loading) return;

    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    } else {
      await _finish();
    }
  }

  Future<void> _onSkip() async {
    if (_loading) return;
    await _finish();
  }

  Future<void> _finish() async {
    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('onboarding_seen', true);

      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId != null) {
        await ProfileRepository(
          Supabase.instance.client,
        ).markOnboardingComplete(userId);
      }

      if (!mounted) return;

      context.go(AppRoutes.auth);
    } catch (e) {
      debugPrint('Onboarding finish error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Something went wrong. Please try again.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            AppBarLogo(
              showSkip: _currentPage < 2,
              onSkip: _onSkip,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) {
                  setState(() => _currentPage = i);
                },
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  OnboardingPageOne(),
                  OnboardingPageTwo(),
                  OnboardingPageThree(),
                ],
              ),
            ),
            _BottomSection(
              currentPage: _currentPage,
              loading: _loading,
              onContinue: _onContinue,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSection extends StatelessWidget {
  final int currentPage;
  final bool loading;
  final VoidCallback onContinue;

  const _BottomSection({
    required this.currentPage,
    required this.loading,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        0,
        24,
        40,
      ),
      child: Column(
        children: [
          _PageIndicator(currentPage: currentPage),
          const SizedBox(height: 20),
          CtaButton(
            label: currentPage == 2 ? 'Get started →' : 'Continue →',
            loading: loading,
            onTap: onContinue,
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;

  const _PageIndicator({
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final active = i == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 6),
          height: 3,
          width: active ? 48 : 28,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
