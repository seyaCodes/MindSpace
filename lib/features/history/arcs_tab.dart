import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'history_provider.dart';
import 'widgets/arc_grid_tile.dart';

class ArcsTab extends ConsumerWidget {
  const ArcsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivedExpanded = ref.watch(historyProvider).archivedExpanded;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        // ACTIVE THREADS header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ACTIVE THREADS',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9B9BA0),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '4 ongoing arcs',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFF5F5F7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 2-col arc grid — uses assets/<color>.png (no subfolder)
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 28,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
          children: [
            ArcGridTile(
              folderAsset: 'assets/purple.png',
              name: 'The Job Hunt',
              sessionCount: 5,
              spiritDots: const [
                Color(0xFF6C5CE7),
                Color(0xFF6C5CE7),
                Color(0xFFF39C12),
                Color(0xFF00C48C),
                Color(0xFF5B8DEF),
              ],
              onTap: () => context.push('/arc/1'),
            ),
            ArcGridTile(
              folderAsset: 'assets/blue.png',
              name: 'Family',
              sessionCount: 3,
              spiritDots: const [
                Color(0xFF5B8DEF),
                Color(0xFF00C48C),
                Color(0xFF6C5CE7),
              ],
              onTap: () => context.push('/arc/2'),
            ),
            ArcGridTile(
              folderAsset: 'assets/gren.png',
              name: 'Relationships',
              sessionCount: 4,
              spiritDots: const [
                Color(0xFFF39C12),
                Color(0xFF5B8DEF),
                Color(0xFF00C48C),
                Color(0xFF6C5CE7),
              ],
              onTap: () => context.push('/arc/3'),
            ),
            ArcGridTile(
              folderAsset: 'assets/orrange.png',
              name: 'Creative Block',
              sessionCount: 2,
              spiritDots: const [
                Color(0xFFF39C12),
                Color(0xFF00C48C),
              ],
              onTap: () => context.push('/arc/4'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Archived divider
        GestureDetector(
          onTap: () =>
              ref.read(historyProvider.notifier).toggleArchived(),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.archive_outlined,
                    color: Color(0xFF9B9BA0), size: 16),
                const SizedBox(width: 8),
                Text(
                  'ARCHIVED CHAPTERS · 2',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9B9BA0),
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                Icon(
                  archivedExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF9B9BA0),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),

        // Archived grid (collapsible)
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: archivedExpanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 28,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                    children: [
                      ArcGridTile(
                        folderAsset: 'assets/teal.png',
                        name: 'Health Routine',
                        subtitle: 'archived · 2',
                        archived: true,
                        onTap: () => context.push('/arc/5'),
                      ),
                      ArcGridTile(
                        folderAsset: 'assets/teal.png',
                        name: 'Perfectionism',
                        subtitle: 'archived · 6',
                        archived: true,
                        onTap: () => context.push('/arc/6'),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}