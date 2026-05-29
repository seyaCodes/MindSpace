import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';

class OnboardingPageTwo extends StatefulWidget {
  const OnboardingPageTwo({super.key});

  @override
  State<OnboardingPageTwo> createState() => _OnboardingPageTwoState();
}

class _OnboardingPageTwoState extends State<OnboardingPageTwo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _float = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
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
            child: Center(
              child: AnimatedBuilder(
                animation: _float,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, _float.value),
                  child: const _FannedFolders(),
                ),
              ),
            ),
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

class _FannedFolders extends StatelessWidget {
  const _FannedFolders();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back folder — pink (Family)
          Positioned(
            left: 10,
            top: 30,
            child: Transform.rotate(
              angle: -0.18,
              child: _FolderCard(
                imagePath: 'assets/pink.png',
                label: 'Family',
              ),
            ),
          ),
          // Middle folder — blue (Job Hunt)
          Positioned(
            left: 55,
            top: 15,
            child: Transform.rotate(
              angle: -0.06,
              child: _FolderCard(
                imagePath: 'assets/blue.png',
                label: 'Job Hunt',
              ),
            ),
          ),
          // Front folder — green (Moving)
          Positioned(
            left: 110,
            top: 0,
            child: Transform.rotate(
              angle: 0.08,
              child: _FolderCard(
                imagePath: 'assets/green.png',
                label: 'Moving',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  final String imagePath;
  final String label;

  const _FolderCard({
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            imagePath,
            width: 130,
            height: 130,
            fit: BoxFit.contain,
          ),
          Positioned(
            bottom: 8,
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
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
          'ARCS, NOT FEEDS',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Stories, not ',
                style: GoogleFonts.dmSans(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: 'streaks.',
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
          'Your conversations cluster into Arcs — chapters that show how a feeling actually moved over time. Sage surfaces patterns you couldn\'t see from inside.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

