import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF0A0E1A);
const _card = Color(0xFF141830);
const _border = Color(0xFF2A2D4A);
const _accent = Color(0xFF6C72FF);
const _cyan = Color(0xFF4DD9C0);
const _textSec = Color(0xFFB0B4C8);
const _textMuted = Color(0xFF6B6F8A);

class ArcAnalysisErrorScreen extends StatelessWidget {
  final String arcTitle;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const ArcAnalysisErrorScreen({
    super.key,
    this.arcTitle = 'The Job Hunt',
    this.onRetry,
    this.onBack,
  });

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
            padding: const EdgeInsets.symmetric(horizontal: 28),
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
                  // Orb with retry badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
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
                      ),
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2240),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: _border, width: 1),
                          ),
                          child: const Icon(Icons.refresh,
                              color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Error heading
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sage couldn\'t\n',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                        TextSpan(
                          text: 'finish this ',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                        TextSpan(
                          text: 'Arc Analysis.',
                          style: GoogleFonts.inter(
                            color: _cyan,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Something interrupted the read-through. Your sessions are still safe — nothing was lost.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: _textSec, fontSize: 13, height: 1.6),
                  ),

                  const SizedBox(height: 22),

                  // Try again button
                  GestureDetector(
                    onTap: onRetry ?? () {},
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_accent, _cyan]),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      alignment: Alignment.center,
                      child: Text('↺  Try again',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'If it keeps happening, your sessions are exportable from Settings — and Sage will pick this up next time.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: _textMuted, fontSize: 11, height: 1.5),
                  ),

                  const SizedBox(height: 14),

                  // Back ghost button
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: _border, width: 0.5),
                      ),
                      alignment: Alignment.center,
                      child: Text('Back to $arcTitle',
                          style: GoogleFonts.inter(
                              color: _textSec,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
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
