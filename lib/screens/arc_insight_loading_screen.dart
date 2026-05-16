import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF0A0E1A);
const _card = Color(0xFF141830);
const _border = Color(0xFF2A2D4A);
const _accent = Color(0xFF6C72FF);
const _cyan = Color(0xFF4DD9C0);
const _textSec = Color(0xFFB0B4C8);
const _textMuted = Color(0xFF6B6F8A);

class ArcInsightLoadingScreen extends StatelessWidget {
  const ArcInsightLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, 0),
            radius: 1.2,
            colors: [Color(0xFF150E2A), _bg],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _border, width: 0.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Orb
                  Container(
                    width: 72,
                    height: 72,
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
                          begin: const Offset(0.94, 0.94),
                          end: const Offset(1.06, 1.06),
                          duration: 1800.ms,
                          curve: Curves.easeInOut),

                  const SizedBox(height: 20),

                  // Title
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                          fontSize: 20, height: 1.4),
                      children: [
                        TextSpan(
                          text: 'Sage is ',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: 'reviewing',
                          style: GoogleFonts.inter(
                              color: _cyan,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic),
                        ),
                        TextSpan(
                          text: ' this Arc.',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Re-reading 5 sessions to find what moved and what stayed still.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: _textSec, fontSize: 13, height: 1.55),
                  ),

                  const SizedBox(height: 20),

                  // Progress bar at ~60%
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 4,
                          color: _border,
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.60,
                          child: Container(
                            height: 4,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [_accent, _cyan]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(
                          duration: 1500.ms,
                          color: Colors.white.withOpacity(0.1)),

                  const SizedBox(height: 10),

                  Text(
                    'READING SESSION 3 OF 5 · ~6 SEC',
                    style: GoogleFonts.inter(
                        color: _textMuted,
                        fontSize: 10,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
