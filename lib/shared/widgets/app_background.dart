import 'package:flutter/material.dart';

import 'package:mind_space/core/theme/app_theme.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3D1F7A),
            Color(0xFF1E1654),
            Color(0xFF0D1B3E),
            Color(0xFF0A1628),
          ],
          stops: [0.0, 0.25, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }
}

class AppBarLogo extends StatelessWidget implements PreferredSizeWidget {
  final bool showSkip;
  final VoidCallback? onSkip;

  const AppBarLogo({
    super.key,
    this.showSkip = false,
    this.onSkip,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0xFFBEB3E8), Color(0xFF9B8FD4)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '✦',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Mind Space',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (showSkip && onSkip != null)
              GestureDetector(
                onTap: onSkip,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
