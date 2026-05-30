import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mind_space/core/theme/app_theme.dart';

class SageOrb extends StatefulWidget {
  final double size;
  final bool breathing;
  final bool showStar;

  const SageOrb({
    super.key,
    this.size = 160,
    this.breathing = true,
    this.showStar = true,
  });

  @override
  State<SageOrb> createState() => _SageOrbState();
}

class _SageOrbState extends State<SageOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _scale = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );

    _glow = Tween<double>(begin: 0.3, end: 0.65).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );

    if (widget.breathing) {
      _ctrl.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.scale(
        scale: widget.breathing ? _scale.value : 1.0,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.orbLavender.withOpacity(
                        widget.breathing ? _glow.value : 0.4,
                      ),
                      blurRadius: 48,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
              // Orb body
              Container(
                width: widget.size * 0.82,
                height: widget.size * 0.82,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(-0.3, -0.3),
                    radius: 0.85,
                    colors: [
                      AppColors.orbLight,
                      AppColors.orbLavender,
                      Color(0xFF6A5ACD),
                    ],
                    stops: [0.0, 0.55, 1.0],
                  ),
                ),
              ),
              // 4-point star
              if (widget.showStar)
                Text(
                  '✦',
                  style: GoogleFonts.dmSans(
                    fontSize: widget.size * 0.22,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
