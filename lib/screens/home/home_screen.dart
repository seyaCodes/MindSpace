import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Hardcoded colors — no AppColors dependency
const _accent    = Color(0xFF338ACA);
const _teal      = Color(0xFF26B7CD);
const _textSec   = Color(0xFF8B92A8);
const _textMuted = Color(0xFF555B7A);

const _hasData = true;

const List<List<Color>> _folderGradients = [
  [Color(0xFF338ACA), Color(0xFF26B7CD)],  // blue-teal
  [Color(0xFF10B981), Color(0xFF34D399)],  // green
  [Color(0xFF8B5CF6), Color(0xFFB78CF7)],  // purple
];

// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF191834),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2B2C68), Color(0xFF191834), Color(0xFF0D1520)],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),
          Positioned(top: -80, right: -60,
              child: _GlowOrb(size: 320, color: const Color(0xFF338ACA).withOpacity(0.50))),
          Positioned(bottom: 60, left: -80,
              child: _GlowOrb(size: 280, color: const Color(0xFF2B2C68).withOpacity(0.70))),
          Positioned(top: 200, right: -40,
              child: _GlowOrb(size: 180, color: const Color(0xFF26B7CD).withOpacity(0.20))),
          SafeArea(
            bottom: false,
            child: _hasData ? const _PopulatedHome() : const _EmptyHome(),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowOrb({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, Colors.transparent]),
    ),
  );
}

// ─── Populated layout ─────────────────────────────────────────────────────────
class _PopulatedHome extends StatelessWidget {
  const _PopulatedHome();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Text('FRIDAY, APRIL 24',
                    style: GoogleFonts.inter(
                      color: _textMuted, fontSize: 11,
                      fontWeight: FontWeight.w500, letterSpacing: 1.6,
                    )),
                const Spacer(),
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.5),
                  ),
                  child: const Icon(Icons.menu, color: Color(0xFF8B9CC8), size: 17),
                ),
              ],
            ),
          ),
        ),

        // Hero greeting
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: 'Morning,\n',
                        style: GoogleFonts.inter(
                          color: Colors.white, fontSize: 44,
                          fontWeight: FontWeight.w700, height: 1.08, letterSpacing: -1.5,
                        )),
                    TextSpan(text: 'Seya.',
                        style: GoogleFonts.inter(
                          color: _teal, fontSize: 44,
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic,
                          height: 1.08, letterSpacing: -1.5,
                        )),
                  ]),
                ),
                const SizedBox(height: 8),
                Text('Pick up where you left off, or start fresh.',
                    style: GoogleFonts.inter(color: _textSec, fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ),

        // Section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
            child: Row(
              children: [
                Text('Open Threads',
                    style: GoogleFonts.inter(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('View all', style: GoogleFonts.inter(color: _teal, fontSize: 13)),
              ],
            ),
          ),
        ),

        // Folder grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.92,
            ),
            delegate: SliverChildListDelegate([
              const _FolderCard(arcName: 'The Job Hunt', timeAgo: '2d ago',    gradientIndex: 0),
              const _FolderCard(arcName: 'Family',       timeAgo: 'Yesterday', gradientIndex: 1),
              const _FolderCard(arcName: 'Relationships',timeAgo: '3d ago',    gradientIndex: 2),
              const _NewThreadCard(),
            ]),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 110)),
      ],
    );
  }
}

// ─── Folder card ──────────────────────────────────────────────────────────────
class _FolderCard extends StatelessWidget {
  final String arcName;
  final String timeAgo;
  final int gradientIndex;
  const _FolderCard({required this.arcName, required this.timeAgo, required this.gradientIndex});

  @override
  Widget build(BuildContext context) {
    final colors      = _folderGradients[gradientIndex % _folderGradients.length];
    final topColor    = colors[0];
    final bottomColor = colors[1];

    return GestureDetector(
      onTap: () => context.go('/free_space'),
      child: Container(
        decoration: BoxDecoration(
          // Subtle gradient tint — folder icon is the hero, not the background
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              topColor.withOpacity(0.22),
              bottomColor.withOpacity(0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: topColor.withOpacity(0.30), width: 0.8),
        ),
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FIX: naked folder — no surrounding box, no backdrop
            Expanded(
              child: Center(
                child: _FolderIcon(accentColor: topColor, highlightColor: bottomColor),
              ),
            ),
            const SizedBox(height: 10),
            Text(arcName,
                style: GoogleFonts.inter(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text(timeAgo,
                style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.45), fontSize: 10.5)),
          ],
        ),
      ),
    );
  }
}

// ─── Naked folder icon — NO wrapping container ─────────────────────────────────
//   Structure: back-body + tab + doc2(tilted right) + doc1(tilted left) + glass flap
//   Nothing surrounds the whole thing.
class _FolderIcon extends StatelessWidget {
  final Color accentColor;
  final Color highlightColor;
  const _FolderIcon({required this.accentColor, required this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 76,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [

          // ── Back body
          Positioned(
            bottom: 0,
            child: Container(
              width: 88,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withOpacity(0.55),
                    accentColor.withOpacity(0.30),
                  ],
                ),
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.30),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),
          ),

          // ── Tab
          Positioned(
            bottom: 52,
            left: 10,
            child: Container(
              width: 28, height: 10,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.55),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
            ),
          ),

          // ── Doc 2 — behind, tilted right
          Positioned(
            bottom: 16,
            child: Transform.rotate(
              angle: 8 * math.pi / 180,
              child: Container(
                width: 38, height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4)],
                ),
                padding: const EdgeInsets.only(top: 8, left: 7, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(double.infinity, 0.18),
                    const SizedBox(height: 5),
                    _line(16, 0.12),
                    const SizedBox(height: 5),
                    _line(20, 0.10),
                  ],
                ),
              ),
            ),
          ),

          // ── Doc 1 — front, tilted left
          Positioned(
            bottom: 16,
            child: Transform.rotate(
              angle: -7 * math.pi / 180,
              child: Container(
                width: 42, height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.93),
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 8,
                        offset: const Offset(0, 3)),
                  ],
                ),
                padding: const EdgeInsets.only(top: 10, left: 8, right: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(double.infinity, 0.16),
                    const SizedBox(height: 5),
                    _line(18, 0.11),
                    const SizedBox(height: 5),
                    _line(24, 0.09),
                    const SizedBox(height: 5),
                    _line(14, 0.07),
                  ],
                ),
              ),
            ),
          ),

          // ── Glass front flap
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(13),
                bottomRight: Radius.circular(13),
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: 88, height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        highlightColor.withOpacity(0.35),
                        accentColor.withOpacity(0.15),
                      ],
                    ),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.45), width: 0.8),
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _line(double width, double opacity) => Container(
    width: width == double.infinity ? null : width,
    height: 2.5,
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(opacity),
      borderRadius: BorderRadius.circular(1.5),
    ),
  );
}

// ─── New thread card ──────────────────────────────────────────────────────────
class _NewThreadCard extends StatelessWidget {
  const _NewThreadCard();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/free_space'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.16), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.20), width: 1.5),
              ),
              child: Icon(Icons.add, color: Colors.white.withOpacity(0.35), size: 20),
            ),
            const SizedBox(height: 10),
            Text('New thread',
                style: GoogleFonts.inter(color: Colors.white.withOpacity(0.25), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────
class _EmptyHome extends StatelessWidget {
  const _EmptyHome();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('FRIDAY, APRIL 24',
              style: GoogleFonts.inter(color: _textMuted, fontSize: 11,
                  fontWeight: FontWeight.w500, letterSpacing: 1.5)),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: 'Hello,\n',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 44,
                      fontWeight: FontWeight.w700, height: 1.1, letterSpacing: -1.5)),
              TextSpan(text: 'Seya.',
                  style: GoogleFonts.inter(color: _teal, fontSize: 44,
                      fontWeight: FontWeight.w600, fontStyle: FontStyle.italic,
                      height: 1.1, letterSpacing: -1.5)),
            ]),
          ),
          const SizedBox(height: 10),
          Text('Your space to reflect, vent, and find clarity.',
              style: GoogleFonts.inter(color: const Color(0xFF8B92A8), fontSize: 15, height: 1.5)),
          const SizedBox(height: 48),
          Center(
            child: CustomPaint(
              size: const Size(200, 200),
              painter: _DashedRingsPainter(),
              child: SizedBox(width: 200, height: 200,
                child: Center(
                  child: Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                          colors: [_accent, _teal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      boxShadow: [BoxShadow(
                          color: _accent.withOpacity(0.4), blurRadius: 24, spreadRadius: 4)],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(child: Text('Tap + to begin your first session',
              style: GoogleFonts.inter(color: _textMuted, fontSize: 14))),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

class _DashedRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint  = Paint()
      ..color      = const Color(0xFF2A2D4A)
      ..strokeWidth = 1
      ..style      = PaintingStyle.stroke;
    for (final r in [60.0, 80.0, 100.0]) {
      double a = 0;
      while (a < 2 * math.pi) {
        canvas.drawArc(Rect.fromCircle(center: center, radius: r), a, 0.18, false, paint);
        a += 0.26;
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}