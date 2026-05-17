import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showOrganizeSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _OrganizeSheet(),
  );
}

class _OrganizeSheet extends StatelessWidget {
  const _OrganizeSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF5A5A60),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Organize arcs',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF5F5F7),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Coming soon.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF9B9BA0),
            ),
          ),
        ],
      ),
    );
  }
}