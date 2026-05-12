import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/arc_model.dart';
import '../session/reflection_screen.dart';
import 'arc_analysis_screen.dart';

class ArcDetailScreen extends StatelessWidget {
  final ArcModel arc;
  const ArcDetailScreen({super.key, required this.arc});

  @override
  Widget build(BuildContext context) {
    const entries = [
      _ArcEntry(date: 'APRIL 22, 2026', color: Color(0xFF10B981),
          desc: 'Chat: 12 mins. Found peace in accepting that perfect isn\'t necessary...'),
      _ArcEntry(date: 'APRIL 20, 2026', color: Color(0xFF8B5CF6),
          desc: 'Chat: 15 mins. Pressure mounting as deadlines approach, questioning preparedness...'),
      _ArcEntry(date: 'APRIL 18, 2026', color: Color(0xFFFBBF24),
          desc: 'Chat: 10 mins. Feeling behind and comparing myself to others...'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.chevron_left, color: Colors.white60, size: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(arc.title,
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${arc.sessionCount} sessions · Apr 15 – Apr 22',
                      style: GoogleFonts.inter(color: Colors.white38, fontSize: 13)),
                  const SizedBox(height: 20),
                  // Generate Arc Analysis button — linked
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ArcAnalysisScreen(arc: arc))),
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A30),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 18),
                          const SizedBox(width: 10),
                          Text('Generate Arc Analysis',
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: entries.length,
                itemBuilder: (_, i) {
                  final e = entries[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ReflectionScreen())),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 11, height: 11,
                                margin: const EdgeInsets.only(top: 3),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: e.color),
                              ),
                              if (i < entries.length - 1)
                                Container(width: 1, height: 60, color: Colors.white12),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.date,
                                    style: GoogleFonts.inter(color: Colors.white38, fontSize: 11, letterSpacing: 1.1)),
                                const SizedBox(height: 5),
                                Text(e.desc,
                                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, height: 1.5)),
                                const SizedBox(height: 6),
                                Text('View Reflection →',
                                    style: GoogleFonts.inter(color: const Color(0xFF8B5CF6), fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcEntry {
  final String date; final Color color; final String desc;
  const _ArcEntry({required this.date, required this.color, required this.desc});
}
