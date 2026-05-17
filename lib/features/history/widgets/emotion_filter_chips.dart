import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionFilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const EmotionFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'All',
            isActive: selected == 'All',
            onTap: () => onChanged('All'),
          ),
          _FilterChip(
            label: 'Anxious',
            dotColor: const Color(0xFF6C5CE7),
            isActive: selected == 'Anxious',
            onTap: () => onChanged('Anxious'),
          ),
          _FilterChip(
            label: 'Sad',
            dotColor: const Color(0xFF5B8DEF),
            isActive: selected == 'Sad',
            onTap: () => onChanged('Sad'),
          ),
          _FilterChip(
            label: 'Calm',
            dotColor: const Color(0xFF00C48C),
            isActive: selected == 'Calm',
            onTap: () => onChanged('Calm'),
          ),
          _FilterChip(
            label: 'Happy',
            dotColor: const Color(0xFFF7D55C),
            isActive: selected == 'Happy',
            onTap: () => onChanged('Happy'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color? dotColor;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.dotColor,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color:
              isActive ? Colors.white.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFF5F5F7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}