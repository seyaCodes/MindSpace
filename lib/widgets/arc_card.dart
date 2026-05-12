import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/arc_model.dart';

class ArcCard extends StatelessWidget {
  final ArcModel arc;
  const ArcCard({super.key, required this.arc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12122A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.folder_outlined,
              color: Color(0xFF8B5CF6), size: 22),
          const Spacer(),
          Text(arc.title,
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('${arc.sessionCount} SESSIONS',
              style: GoogleFonts.inter(
                  color: Colors.white38,
                  fontSize: 11,
                  letterSpacing: 1.0)),
          const SizedBox(height: 10),
          Row(
            children: arc.dotColors.map((c) {
              return Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(shape: BoxShape.circle, color: c),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}