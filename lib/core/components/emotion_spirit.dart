import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class EmotionSpirit extends StatelessWidget {
  final int spiritId;
  final double size;

  const EmotionSpirit({super.key, required this.spiritId, this.size = 80});

  static Color colorFor(int id) => switch (id) {
        1 => AppColors.accentPurple,
        2 => AppColors.accentGreen,
        3 => AppColors.accentOrange,
        4 => AppColors.accentBlue,
        5 => const Color(0xFFA8E063),
        6 => const Color(0xFFE17055),
        _ => AppColors.accentPurple,
      };

  @override
  Widget build(BuildContext context) {
    final color = colorFor(spiritId);
    final orb = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.92),
            color.withValues(alpha: 0.55),
            color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: size * 0.55,
            spreadRadius: size * 0.05,
          ),
        ],
      ),
    );
    return _animated(orb, spiritId);
  }

  Widget _animated(Widget orb, int id) => switch (id) {
        1 => orb
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(0.93, 0.93),
              end: const Offset(1.07, 1.07),
              duration: 600.ms,
              curve: Curves.easeInOut,
            ),
        2 => orb
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(0.91, 0.91),
              end: const Offset(1.05, 1.05),
              duration: 2500.ms,
              curve: Curves.easeInOut,
            ),
        3 => orb
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(0.94, 0.94),
              end: const Offset(1.06, 1.06),
              duration: 1200.ms,
              curve: Curves.easeInOut,
            ),
        4 => orb
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: -4, end: 4, duration: 3000.ms, curve: Curves.easeInOut)
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.03, 1.03),
              duration: 3000.ms,
            ),
        5 => orb
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 5, end: -5, duration: 2200.ms, curve: Curves.easeInOut)
            .scale(
              begin: const Offset(0.94, 0.94),
              end: const Offset(1.04, 1.04),
              duration: 2200.ms,
            ),
        6 => orb
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(0.85, 0.92),
              end: const Offset(1.1, 1.04),
              duration: 380.ms,
              curve: Curves.elasticOut,
            ),
        _ => orb
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(0.91, 0.91),
              end: const Offset(1.05, 1.05),
              duration: 2500.ms,
              curve: Curves.easeInOut,
            ),
      };
}
