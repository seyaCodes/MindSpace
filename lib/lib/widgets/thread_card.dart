import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreadCard extends StatelessWidget {
  final String arcTitle;
  final String lastMessage;
  final List<Color> dotColors;

  const ThreadCard({
    super.key,
    required this.arcTitle,
    required this.lastMessage,
    required this.dotColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF141420),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle folder icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
            child: const Icon(Icons.folder_outlined,
                color: Colors.white54, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(arcTitle,
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(lastMessage,
                    style: GoogleFonts.inter(
                        color: Colors.white54,
                        fontSize: 14,
                        height: 1.5)),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: dotColors.map((c) => Container(
                            width: 11,
                            height: 11,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: c),
                          )).toList(),
                    ),
                    Text('Continue →',
                        style: GoogleFonts.inter(
                            color: const Color(0xFF8B5CF6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
