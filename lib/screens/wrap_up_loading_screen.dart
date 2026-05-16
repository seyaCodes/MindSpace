import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF0A0E1A);
const _accent = Color(0xFF6C72FF);
const _cyan = Color(0xFF4DD9C0);
const _textSec = Color(0xFFB0B4C8);

class WrapUpLoadingScreen extends StatelessWidget {
  const WrapUpLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, 0.1),
            radius: 1.3,
            colors: [Color(0xFF150E2A), _bg],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Orb with pulsing rings
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer pulse ring 2
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _accent.withOpacity(0.15), width: 1),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.3, 1.3),
                            duration: 2000.ms,
                            curve: Curves.easeOut)
                        .fade(
                            begin: 0.5,
                            end: 0.0,
                            duration: 2000.ms,
                            curve: Curves.easeOut),
                    // Inner pulse ring
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _accent.withOpacity(0.25), width: 1),
                      ),
                    )
                        .animate(
                            delay: 600.ms, onPlay: (c) => c.repeat())
                        .scale(
                            begin: const Offset(0.7, 0.7),
                            end: const Offset(1.2, 1.2),
                            duration: 2000.ms,
                            curve: Curves.easeOut)
                        .fade(
                            begin: 0.6,
                            end: 0.0,
                            duration: 2000.ms,
                            curve: Curves.easeOut),
                    // Static ring
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF2A2D4A), width: 0.8),
                      ),
                    ),
                    // Orb
                    Container(
                      width: 90,
                      height: 90,
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
                            duration: 1800.ms,
                            curve: Curves.easeInOut),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // "Sage is sitting with this..."
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Sage is sitting\n',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                    TextSpan(
                      text: 'with this...',
                      style: GoogleFonts.inter(
                        color: _cyan,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Looking back through what you shared and finding the thread underneath.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: _textSec, fontSize: 14, height: 1.6),
                ),
              ),

              const SizedBox(height: 28),

              // Loading dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _accent,
                    ),
                  )
                      .animate(
                          delay: (i * 250).ms,
                          onPlay: (c) => c.repeat(reverse: true))
                      .fade(
                          begin: 0.25,
                          end: 1.0,
                          duration: 600.ms,
                          curve: Curves.easeInOut);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
