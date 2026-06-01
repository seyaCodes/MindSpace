import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisHeader extends StatelessWidget {
  const AnalysisHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis',
          style: GoogleFonts.dmSans(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Patterns across all of your arcs.',
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
