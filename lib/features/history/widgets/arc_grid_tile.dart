import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArcGridTile extends StatelessWidget {
  final String folderAsset;
  final String name;
  final int? sessionCount;
  final String? subtitle;
  final List<Color> spiritDots;
  final bool archived;
  final VoidCallback? onTap;

  const ArcGridTile({
    super.key,
    required this.folderAsset,
    required this.name,
    this.sessionCount,
    this.subtitle,
    this.spiritDots = const [],
    this.archived = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: archived ? 0.5 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  folderAsset,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF5F5F7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle ?? '$sessionCount sessions',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                color: const Color(0xFF9B9BA0),
              ),
            ),
            if (spiritDots.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: spiritDots
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}