import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF0A0E1A);
const _card = Color(0xFF141830);
const _accent = Color(0xFF5C58ED);
const _teal = Color(0xFF3FA9F5);
const _textSec = Color(0xFFB0B4C8);
const _textMuted = Color(0xFF6B6F8A);

class ReflectionScreen extends StatelessWidget {
  const ReflectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Purple glow top
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF5C58ED).withOpacity(0.3),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.chevron_left,
                              color: Colors.white, size: 28),
                        ),
                      ),
                      Text('Session Reflection',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status pill
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: _teal.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: _teal.withOpacity(0.25), width: 0.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.auto_awesome,
                                      color: _teal, size: 12),
                                  const SizedBox(width: 6),
                                  Text('SESSION REFLECTION · JUST GENERATED',
                                      style: GoogleFonts.inter(
                                          color: _teal,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.6)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Date + arc
                        Text('FRIDAY, APRIL 24 · THE JOB HUNT',
                            style: GoogleFonts.inter(
                                color: _textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8)),
                        const SizedBox(height: 10),

                        // Title
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Here's what\n",
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      height: 1.15)),
                              TextSpan(
                                  text: 'Sage noticed.',
                                  style: GoogleFonts.inter(
                                      color: _teal,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      height: 1.15)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── SAGE SENSED ───────────────────────────────
                        _GlassCard(
                          accentColor: const Color(0xFF8B5CF6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Purple orb
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(colors: [
                                        const Color(0xFF9D8FFF),
                                        const Color(0xFF8B5CF6),
                                        const Color(0xFF5C58ED).withOpacity(0.3),
                                      ]),
                                      boxShadow: [
                                        BoxShadow(
                                            color: const Color(0xFF8B5CF6)
                                                .withOpacity(0.45),
                                            blurRadius: 18,
                                            spreadRadius: 2)
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('SAGE SENSED',
                                            style: GoogleFonts.inter(
                                                color: const Color(0xFF10B981),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.8)),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Container(
                                                width: 9,
                                                height: 9,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xFF8B5CF6))),
                                            const SizedBox(width: 7),
                                            Text('Anxiety',
                                                style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text('layered with underlying ',
                                                style: GoogleFonts.inter(
                                                    color: _textMuted,
                                                    fontSize: 12)),
                                            Container(
                                                width: 7,
                                                height: 7,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xFF3B82F6))),
                                            const SizedBox(width: 5),
                                            Text('Shame',
                                                style: GoogleFonts.inter(
                                                    color: const Color(
                                                        0xFF3B82F6),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Text(
                                '"You expressed feeling overwhelmed by the fear of judgment, rather than the presentation itself."',
                                style: GoogleFonts.inter(
                                    color: _textSec,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    height: 1.55),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── ARC UPDATED ───────────────────────────────
                        _GlassCard(
                          accentColor: _teal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.folder_outlined,
                                      color: _teal, size: 14),
                                  const SizedBox(width: 6),
                                  Text('ARC UPDATED',
                                      style: GoogleFonts.inter(
                                          color: _teal,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8)),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _teal.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: _teal.withOpacity(0.3),
                                          width: 0.5),
                                    ),
                                    child: Text('+1 session',
                                        style: GoogleFonts.inter(
                                            color: _teal,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text('The Job Hunt',
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text(
                                'This session deepened your Arc. The theme shifted from external job pressure to internal fear of judgment.',
                                style: GoogleFonts.inter(
                                    color: _textSec, fontSize: 13, height: 1.5),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: _teal.withOpacity(0.5),
                                          width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check,
                                            color: _teal, size: 13),
                                        const SizedBox(width: 5),
                                        Text('Confirm',
                                            style: GoogleFonts.inter(
                                                color: _teal,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text('Rename Arc',
                                      style: GoogleFonts.inter(
                                          color: _textMuted, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── A SHARED PERSPECTIVE ──────────────────────
                        _GlassCard(
                          accentColor: const Color(0xFF5B8DEF),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.chat_bubble_outline,
                                      color: Color(0xFF5B8DEF), size: 14),
                                  const SizedBox(width: 6),
                                  Text('A SHARED PERSPECTIVE',
                                      style: GoogleFonts.inter(
                                          color: const Color(0xFF5B8DEF),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.55),
                                  children: const [
                                    TextSpan(
                                        text:
                                            "It's common to feel the weight of external expectations. Many people find that the "),
                                    TextSpan(
                                        text: 'fear of judgment',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    TextSpan(
                                        text:
                                            ' is often more powerful than the actual event.'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'What would you tell a friend facing this same worry?',
                                style: GoogleFonts.inter(
                                    color: _textMuted,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    height: 1.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── YOUR MOMENT OF CLARITY ────────────────────
                        _GlassCard(
                          accentColor: const Color(0xFFF59E0B),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.lightbulb_outline,
                                      color: Color(0xFFF59E0B), size: 14),
                                  const SizedBox(width: 6),
                                  Text('YOUR MOMENT OF CLARITY',
                                      style: GoogleFonts.inter(
                                          color: const Color(0xFFF59E0B),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "You realized the pressure you're feeling isn't about the job itself, but about how others perceive your performance.",
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.55),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Recognizing this distinction is the first step to reclaiming your focus.',
                                style: GoogleFonts.inter(
                                    color: _textMuted,
                                    fontSize: 13,
                                    height: 1.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── QUESTIONS TO CARRY WITH YOU ───────────────
                        _GlassCard(
                          accentColor: _teal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: _teal, width: 1.5),
                                    ),
                                    child: const Icon(Icons.question_mark,
                                        color: _teal, size: 9),
                                  ),
                                  const SizedBox(width: 6),
                                  Text('QUESTIONS TO CARRY WITH YOU',
                                      style: GoogleFonts.inter(
                                          color: _teal,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8)),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _QuestionBullet(
                                'What would it feel like to reframe "failure" as "learning" for tomorrow?',
                              ),
                              const SizedBox(height: 10),
                              _QuestionBullet(
                                "How can you acknowledge your preparation, even if it doesn't feel \"perfect\"?",
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No need to answer here. Just let these sit with you.',
                                style: GoogleFonts.inter(
                                    color: _textMuted,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),

                // Bottom CTA
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text('Save Reflection & Continue',
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward,
                              color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  const _GlassCard({required this.child, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Color.lerp(_card, accentColor, 0.06)!.withOpacity(0.80),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: accentColor.withOpacity(0.18), width: 0.5),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _QuestionBullet extends StatelessWidget {
  final String text;
  const _QuestionBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 6, right: 8),
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: _teal),
        ),
        Expanded(
          child: Text(text,
              style: GoogleFonts.inter(
                  color: Colors.white, fontSize: 13, height: 1.5)),
        ),
      ],
    );
  }
}
