import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistorySearchBar extends StatelessWidget {
  const HistorySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF5A5A60), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: GoogleFonts.inter(
                fontSize: 15,
                color: const Color(0xFFF5F5F7),
              ),
              decoration: InputDecoration(
                hintText: 'Search your reflections...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color(0xFF5A5A60),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const Icon(Icons.tune, color: Color(0xFF5A5A60), size: 20),
        ],
      ),
    );
  }
}