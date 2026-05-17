import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';

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
            padding: const EdgeInsets.fromLTRB(20, 11, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Date label ──────────────────────────────────
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

                // ── Greeting ─────────────────────────────────────
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

                // ── Subtitle ──────────────────────────────────────
                Text(
                  'Pick up where you left off, or start fresh.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9B9BA0),
                  ),
                ),

                const SizedBox(height: 30),

                // ── "Open threads" / "view all >" ────────────────
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

                // ── 2×2 floating folder grid ──────────────────────
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _ArcCard(
                      folderAsset: 'assets/purple.png',
                      name: 'The Job Hunt',
                      subtitle: '2d ago',
                      ambientBreath: true,
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
// ARC CARD — folder floats on background, label below
// Press: scale(0.97) 100ms ease-out
// Optional: ambient 3s breath on the folder illustration
// ═══════════════════════════════════════════════════════════
class _ArcCard extends StatefulWidget {
  final String folderAsset;
  final String name;
  final String subtitle;
  final bool ambientBreath;
  final VoidCallback onTap;

  const _ArcCard({
    required this.folderAsset,
    required this.name,
    required this.subtitle,
    required this.onTap,
    this.ambientBreath = false,
  });

  @override
  State<_ArcCard> createState() => _ArcCardState();
}

class _ArcCardState extends State<_ArcCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    reverseDuration: const Duration(milliseconds: 150),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.97)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _folderImage() {
    final img = ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 115),
      child: Image.asset(
        widget.folderAsset,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
    if (!widget.ambientBreath) return img;
    return img
        .animate(onPlay: (ctrl) => ctrl.repeat(reverse: true))
        .scale(
          begin: const Offset(0.97, 0.97),
          end: const Offset(1.0, 1.0),
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(child: _folderImage()),
            ),
            const SizedBox(height: 12),
            Text(
              widget.name,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF5F5F7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF9B9BA0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// NEW THREAD CARD — floating + icon and label, no container
// Same press animation as arc cards
// ═══════════════════════════════════════════════════════════
class _NewThreadCard extends StatefulWidget {
  final VoidCallback onTap;
  const _NewThreadCard({required this.onTap});

  @override
  State<_NewThreadCard> createState() => _NewThreadCardState();
}

class _NewThreadCardState extends State<_NewThreadCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    reverseDuration: const Duration(milliseconds: 150),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.97)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  Icons.add_circle_outline,
                  color: AppColors.accentPurple.withOpacity(0.7),
                  size: 52,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'New thread',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF5F5F7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'start fresh',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF9B9BA0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
