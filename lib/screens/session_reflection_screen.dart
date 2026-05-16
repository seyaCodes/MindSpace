import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF0A0E1A);
const _card = Color(0xFF141830);
const _border = Color(0xFF2A2D4A);
const _accent = Color(0xFF6C72FF);
const _cyan = Color(0xFF4DD9C0);
const _textSec = Color(0xFFB0B4C8);
const _textMuted = Color(0xFF6B6F8A);

class SessionReflectionScreen extends StatelessWidget {
  const SessionReflectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(Icons.chevron_left,
                            color: _textSec, size: 22),
                        Text('History',
                            style: GoogleFonts.inter(
                                color: _textSec, fontSize: 15)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text('Session Reflection',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _border, width: 0.5),
                    ),
                    child: Text('Read-only',
                        style: GoogleFonts.inter(
                            color: _textMuted, fontSize: 11)),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Date/time/duration
                  Text(
                    'Apr 24, 2026 · 8:00 PM · 14 min',
                    style: GoogleFonts.inter(
                        color: _textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  // Heading
                  Text('Session',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          height: 1.1)),
                  Text('Reflection.',
                      style: GoogleFonts.inter(
                          color: _cyan,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          height: 1.1)),

                  const SizedBox(height: 20),

                  // Arc pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.folder_outlined,
                            color: _textMuted, size: 15),
                        const SizedBox(width: 8),
                        Text('ARC',
                            style: GoogleFonts.inter(
                                color: _textMuted,
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Text('The Job Hunt',
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        const Icon(Icons.chevron_right,
                            color: _textMuted, size: 18),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Emotion card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
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
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('SAGE SENSED',
                                      style: GoogleFonts.inter(
                                          color: _textMuted,
                                          fontSize: 10,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _accent),
                                      ),
                                      const SizedBox(width: 8),
                                      Text('Anxious',
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight:
                                                  FontWeight.w600)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '"The waiting is the hardest part — you\'re not anxious about the interview itself, you\'re anxious about the silence."',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              height: 1.6),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.edit_outlined,
                                color: _textMuted, size: 14),
                            const SizedBox(width: 6),
                            Text('Sage got this wrong? Change emotion',
                                style: GoogleFonts.inter(
                                    color: _textMuted, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Shared perspective card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.format_quote,
                                color: _cyan, size: 20),
                            const SizedBox(width: 8),
                            Text('A SHARED PERSPECTIVE',
                                style: GoogleFonts.inter(
                                    color: _textMuted,
                                    fontSize: 10,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'You\'ve been showing up consistently even when the waiting feels unbearable. That\'s not nothing — that\'s discipline in the middle of uncertainty.',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.6),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'What would it feel like to trust the work you\'ve already done?',
                          style: GoogleFonts.inter(
                              color: _textSec,
                              fontSize: 13,
                              height: 1.5,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _border, width: 0.5),
                      ),
                      alignment: Alignment.center,
                      child: Text('Close Reflection ›',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
