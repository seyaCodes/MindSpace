import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Date label ──────────────────────────────
                Text(
                  'FRIDAY, APRIL 24',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9B9BA0),
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 16),

                // ── Greeting "Morning," / "Seya." ───────────
                Text(
                  'Morning,',
                  style: GoogleFonts.inter(
                    fontSize: 56,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF5F5F7),
                    height: 1.05,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFF5F5F7), Color(0xFFB8A8E8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'Seya.',
                    style: GoogleFonts.inter(
                      fontSize: 56,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.05,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Subtitle ────────────────────────────────
                Text(
                  'Pick up where you left off, or start fresh.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9B9BA0),
                  ),
                ),

                const SizedBox(height: 40),

                // ── "Open threads" / "view all >" ───────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Open threads',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF5F5F7),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/history?tab=arcs'),
                      child: Text(
                        'view all ›',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7AB6F5),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── 2×2 grid of arc cards + new thread ──────
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _ArcCard(
                      folderAsset: 'assets/purple.png',
                      name: 'The Job Hunt',
                      subtitle: '2d ago',
                      onTap: () => context.push('/arc/1'),
                    ),
                    _ArcCard(
                      folderAsset: 'assets/blue.png',
                      name: 'Family',
                      subtitle: 'yesterday',
                      onTap: () => context.push('/arc/2'),
                    ),
                    _ArcCard(
                      folderAsset: 'assets/teal.png',
                      name: 'Relationships',
                      subtitle: '3d ago',
                      onTap: () => context.push('/arc/3'),
                    ),
                    _NewThreadCard(
                      onTap: () => context.push('/chat'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ARC CARD — folder PNG with name + date below
// ═══════════════════════════════════════════════════════════
class _ArcCard extends StatelessWidget {
  final String folderAsset;
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  const _ArcCard({
    required this.folderAsset,
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                folderAsset,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF5F5F7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9B9BA0),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// NEW THREAD CARD — dashed circle with + and "New Thread"
// ═══════════════════════════════════════════════════════════
class _NewThreadCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NewThreadCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: CustomPaint(
                painter: _DashedCirclePainter(
                  color: const Color(0xFF9B9BA0).withOpacity(0.5),
                  strokeWidth: 1.5,
                  gap: 6,
                  dashLength: 4,
                ),
                child: const SizedBox(
                  width: 140,
                  height: 140,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Color(0xFFB8B8C0),
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // empty space matching arc card name height
          const SizedBox(height: 22),
          Text(
            'New Thread',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9B9BA0),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// DASHED CIRCLE PAINTER — for the "New Thread" card
// ═══════════════════════════════════════════════════════════
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;

  _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dashLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final radius = (size.width < size.height ? size.width : size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * 3.141592653589793 * radius;
    final dashCount = (circumference / (dashLength + gap)).floor();
    final adjustedGap =
        (circumference - (dashCount * dashLength)) / dashCount;
    final dashAngle = dashLength / radius;
    final gapAngle = adjustedGap / radius;

    double currentAngle = -3.141592653589793 / 2;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        dashAngle,
        false,
        paint,
      );
      currentAngle += dashAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.gap != gap ||
      oldDelegate.dashLength != dashLength;
}