import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080810),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, kNavBarTotalHeight),
          children: [
            const SizedBox(height: 48),
            Center(child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(colors: [Color(0xFF7C3AED), Color(0xFF4C1D95), Color(0xFF1E1B4B)], stops: [0.0, 0.5, 1.0]),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.5), blurRadius: 40, spreadRadius: 6),
                  BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.2), blurRadius: 80, spreadRadius: 12),
                ],
              ),
            )),
            const SizedBox(height: 22),
            Center(child: Text('Insights', style: GoogleFonts.inter(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))),
            const SizedBox(height: 4),
            Center(child: Text('Your cognitive patterns.', style: GoogleFonts.inter(color: Colors.white38, fontSize: 13))),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF12122A), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.08))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PATTERNS SAGE NOTICED', style: GoogleFonts.inter(color: Colors.white38, fontSize: 11, letterSpacing: 1.3)),
                const SizedBox(height: 16),
                Text('You tend to start sessions talking about external pressures but often land on questions about identity and authenticity.', style: GoogleFonts.inter(color: Colors.white, fontSize: 14, height: 1.6)),
                const SizedBox(height: 16),
                Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 16),
                RichText(text: TextSpan(style: GoogleFonts.inter(color: Colors.white, fontSize: 14, height: 1.6), children: const [
                  TextSpan(text: 'The word '),
                  TextSpan(text: '"should"', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                  TextSpan(text: ' appears in 7 of your last 10 sessions — often right before a breakthrough moment.'),
                ])),
              ]),
            ),
            const SizedBox(height: 16),
            Container(
              height: 140,
              decoration: BoxDecoration(color: const Color(0xFF0E0E20), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.05))),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.lock_outline, color: Colors.white24, size: 30),
                const SizedBox(height: 12),
                Text('April Reflection', style: GoogleFonts.inter(color: Colors.white38, fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text('Unlocks in 3 sessions.', style: GoogleFonts.inter(color: Colors.white24, fontSize: 12)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
