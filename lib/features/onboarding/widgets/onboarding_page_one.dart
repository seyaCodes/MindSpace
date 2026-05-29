import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import 'package:mind_space/shared/widgets/sage_orb.dart';

class OnboardingPageOne extends StatefulWidget {
  const OnboardingPageOne({super.key});

  @override
  State<OnboardingPageOne> createState() => _OnboardingPageOneState();
}

class _OnboardingPageOneState extends State<OnboardingPageOne>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _orbit;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _orbit = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            flex: 5,
            child: Center(child: _OrbWithSatellites(orbit: _orbit)),
          ),
          Expanded(
            flex: 4,
            child: _Copy(),
          ),
        ],
      ),
    );
  }
}

class _OrbWithSatellites extends StatelessWidget {
  final Animation<double> orbit;

  const _OrbWithSatellites({required this.orbit});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: orbit,
      builder: (_, __) {
        const orbitRadius = 110.0;
        final teal = _satelliteOffset(orbit.value, orbitRadius, phase: 0.0);
        final blue = _satelliteOffset(orbit.value, orbitRadius, phase: 0.45);

        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Orbit ring
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 1,
                  ),
                ),
              ),
              const SageOrb(size: 150, breathing: true),
              // Teal satellite
              Transform.translate(
                offset: teal,
                child: _Satellite(
                  size: 44,
                  color: AppColors.accentTeal,
                ),
              ),
              // Blue satellite
              Transform.translate(
                offset: blue,
                child: _Satellite(
                  size: 36,
                  color: AppColors.accentBlue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Offset _satelliteOffset(double t, double r, {required double phase}) {
    final angle = (t + phase) * 2 * 3.141592653589793;
    return Offset(r * 0.85 * _cos(angle), r * 0.55 * _sin(angle));
  }

  double _cos(double a) => (a == 0) ? 1 : (Offset(1, 0)..scale(1, 0)).dx * 0 + _mathCos(a);
  double _sin(double a) => _mathSin(a);

  double _mathCos(double a) {
    // dart:math not imported — use trig identity via offset
    return Offset.fromDirection(a).dx;
  }

  double _mathSin(double a) {
    return Offset.fromDirection(a).dy;
  }
}

class _Satellite extends StatelessWidget {
  final double size;
  final Color color;

  const _Satellite({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.95),
            color.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _Copy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MEET SAGE',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'A quiet place for\n',
                style: GoogleFonts.dmSans(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: "what's loud.",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 34,
                  fontStyle: FontStyle.italic,
                  color: AppColors.accentPurple,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Mind Space is a calm chat with Sage — an AI that listens before it solves. No streaks, no scores. Just room to think out loud.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

