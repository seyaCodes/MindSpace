import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReflectionScreen extends StatelessWidget {
  const ReflectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('APRIL 22, 2026',
                  style: GoogleFonts.inter(
                      color: Colors.white38,
                      fontSize: 11,
                      letterSpacing: 1.3)),
              const SizedBox(height: 6),
              Text('Your Reflection',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('A moment of clarity.',
                  style: GoogleFonts.inter(
                      color: Colors.white38, fontSize: 13)),
              const SizedBox(height: 24),

              // ── Detected emotion card ─────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF12122A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.07)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Glowing green dot
                    Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF10B981),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.6),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DETECTED EMOTION',
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF10B981),
                                  fontSize: 10,
                                  letterSpacing: 1.3,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  height: 1.55),
                              children: const [
                                TextSpan(text: 'Sage sensed '),
                                TextSpan(
                                    text: 'Calm',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                TextSpan(
                                    text:
                                        '. You expressed finding closure today regarding your anxiety around expectations.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Arc updated card ──────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF12122A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.07)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.folder_outlined,
                            color: Color(0xFF8B5CF6), size: 15),
                        const SizedBox(width: 6),
                        Text('THE JOB HUNT',
                            style: GoogleFonts.inter(
                                color: Colors.white54,
                                fontSize: 11,
                                letterSpacing: 0.9,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('ARC UPDATED',
                              style: GoogleFonts.inter(
                                  color: Colors.white54,
                                  fontSize: 9,
                                  letterSpacing: 0.8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your anxiety shifted to preparation. You\'re beginning to focus on what you can control rather than external validation.',
                      style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.55),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Tension noticed card ──────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF12122A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.07)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.compare_arrows,
                            color: Colors.white38, size: 16),
                        const SizedBox(width: 6),
                        Text('A TENSION NOTICED',
                            style: GoogleFonts.inter(
                                color: Colors.white38,
                                fontSize: 11,
                                letterSpacing: 1.1)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _TensionBox(
                      label: 'YOU MINIMIZED...',
                      quote:
                          '"It\'s probably not that big of a deal, everyone deals with this."',
                    ),
                    const SizedBox(height: 10),
                    _TensionBox(
                      label: 'YOU REVEALED...',
                      quote:
                          '"I feel like I\'m constantly performing and I don\'t know who I actually am."',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // ── Save & Close button ───────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFF8B5CF6),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withOpacity(0.5),
                        blurRadius: 24,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Save & Close',
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TensionBox extends StatelessWidget {
  final String label;
  final String quote;
  const _TensionBox({required this.label, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A32),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  color: Colors.white38,
                  fontSize: 10,
                  letterSpacing: 1.1)),
          const SizedBox(height: 8),
          Text(quote,
              style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 13.5,
                  fontStyle: FontStyle.italic,
                  height: 1.45)),
        ],
      ),
    );
  }
}
