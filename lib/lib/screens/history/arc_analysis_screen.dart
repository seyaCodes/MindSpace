import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/arc_model.dart';

class ArcAnalysisScreen extends StatelessWidget {
  final ArcModel arc;
  const ArcAnalysisScreen({super.key, required this.arc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white54, size: 24),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon + title
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF8B5CF6).withOpacity(0.15),
                            ),
                            child: const Icon(Icons.auto_awesome,
                                color: Color(0xFF8B5CF6), size: 26),
                          ),
                          const SizedBox(height: 16),
                          Text(arc.title,
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Arc Analysis · ${arc.sessionCount} sessions',
                              style: GoogleFonts.inter(
                                  color: Colors.white38, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // How this arc evolved
                    _SectionCard(
                      label: 'HOW THIS ARC EVOLVED',
                      content:
                          'Your earliest sessions were dominated by external pressures — what you thought companies expected. By your most recent session, the conversation shifted. You stopped asking "am I doing enough" and started asking "what environment do I actually want?"',
                    ),
                    const SizedBox(height: 16),

                    // A pattern Sage noticed
                    _SectionCard(
                      label: 'A PATTERN SAGE NOTICED',
                      content:
                          'Every time you expressed calm around this topic, it came after naming a specific fear rather than solving it. The relief wasn\'t in having answers — it was in finally saying the uncomfortable part out loud.',
                    ),
                    const SizedBox(height: 16),

                    // A question to sit with
                    _SectionCard(
                      label: 'A QUESTION TO SIT WITH',
                      content:
                          '"What would it look like to prepare for interviews in a way that felt true to you, even if it didn\'t look like everyone else\'s process?"',
                      isQuote: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String label;
  final String content;
  final bool isQuote;
  const _SectionCard({required this.label, required this.content, this.isQuote = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF12122A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  color: Colors.white38,
                  fontSize: 10,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(content,
              style: GoogleFonts.inter(
                  color: isQuote ? Colors.white : Colors.white70,
                  fontSize: isQuote ? 15 : 14,
                  fontStyle: isQuote ? FontStyle.italic : FontStyle.normal,
                  height: 1.6)),
        ],
      ),
    );
  }
}
