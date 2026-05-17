import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════
// TIMELINE SESSION CARD — illuminated emotion-tinted card
// REPLACES the old version
// Subtle gradient using emotion color, no explicit ANXIOUS/CALM tag
// ═══════════════════════════════════════════════════════════

class TimelineSessionCard extends StatelessWidget {
  final Color arcColor;
  final String arcName;
  final String arcTitle;
  final String arcTitleHighlight;
  final Color? highlightColor;
  final String time;
  final String quote;
  final bool showViewReflection;
  final VoidCallback? onTap;
  final VoidCallback? onViewReflection;

  const TimelineSessionCard({
    super.key,
    required this.arcColor,
    required this.arcName,
    required this.arcTitle,
    required this.arcTitleHighlight,
    this.highlightColor,
    required this.time,
    required this.quote,
    required this.showViewReflection,
    this.onTap,
    this.onViewReflection,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              arcColor.withOpacity(0.12),
              arcColor.withOpacity(0.04),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: arcColor.withOpacity(0.35),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: arcColor.withOpacity(0.08),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Arc pill (small label)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: arcColor.withOpacity(0.25),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.folder_outlined,
                        color: arcColor.withOpacity(0.8),
                        size: 12,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        arcName,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: arcColor.withOpacity(0.9),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    color: const Color(0xFF9B9BA0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: arcTitle.replaceAll(arcTitleHighlight, ''),
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF5F5F7),
                    ),
                  ),
                  TextSpan(
                    text: arcTitleHighlight,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: highlightColor ?? arcColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              quote,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFFD0D0D8),
                height: 1.5,
              ),
            ),
            if (showViewReflection) ...[
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onViewReflection ?? onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: arcColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: arcColor.withOpacity(0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: arcColor, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'View Reflection',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFF5F5F7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}