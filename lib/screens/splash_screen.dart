import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF0A0E1A);
const _cyan = Color(0xFF4DD9C0);
const _textSec = Color(0xFFB0B4C8);

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.2,
            colors: [Color(0xFF1C1640), _bg],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Orb with concentric rings
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF2A2D4A).withOpacity(0.4),
                            width: 0.8),
                      ),
                    ),
                    // Middle ring
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF2A2D4A).withOpacity(0.6),
                            width: 0.8),
                      ),
                    ),
                    // Purple orb
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xFF9D97FF),
                            Color(0xFF6C72FF),
                            Color(0xFF4840CC)
                          ],
                          stops: [0.0, 0.55, 1.0],
                        ),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1.05, 1.05),
                            duration: 2200.ms,
                            curve: Curves.easeInOut),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // "Mind Space" title
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Mind ',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'Space',
                      style: GoogleFonts.inter(
                        color: _cyan,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'A quiet room for what\'s loud',
                style: GoogleFonts.inter(
                    color: _textSec, fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
