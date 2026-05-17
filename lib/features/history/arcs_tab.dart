import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme.dart';
import 'history_provider.dart';
import 'widgets/arc_grid_tile.dart';

class ArcsTab extends ConsumerStatefulWidget {
  const ArcsTab({super.key});

  @override
  ConsumerState<ArcsTab> createState() => _ArcsTabState();
}

class _ArcsTabState extends ConsumerState<ArcsTab> {
  bool _showEmotionLegend = false;
  Timer? _legendTimer;

  @override
  void initState() {
    super.initState();
    _checkEmotionLegend();
  }

  @override
  void dispose() {
    _legendTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmotionLegend() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('emotion_dots_legend_seen') ?? false;
    if (!seen && mounted) {
      setState(() => _showEmotionLegend = true);
      _legendTimer = Timer(const Duration(seconds: 3), () async {
        if (mounted) setState(() => _showEmotionLegend = false);
        await prefs.setBool('emotion_dots_legend_seen', true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final archivedExpanded = ref.watch(historyProvider).archivedExpanded;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        // Header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ACTIVE THREADS',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '4 ongoing arcs',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 2-col arc grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
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

        // Emotion dot legend — one-time, 3-second tooltip
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: _showEmotionLegend
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _EmotionDotLegend(),
                )
              : const SizedBox.shrink(),
        ),

        const SizedBox(height: 24),

        // Archived divider
        GestureDetector(
          onTap: () => ref.read(historyProvider.notifier).toggleArchived(),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.archive_outlined,
                    color: AppColors.textTertiary, size: 16),
                const SizedBox(width: 8),
                Text(
                  'ARCHIVED CHAPTERS · 2',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                Icon(
                  archivedExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textTertiary,
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
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
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

class _EmotionDotLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              _dot(AppColors.accentPurple),
              _dot(AppColors.accentOrange),
              _dot(AppColors.accentGreen),
              _dot(AppColors.accentBlue),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Each dot is a session\'s dominant emotion — purple anxious, orange frustrated, green calm, blue sad.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color c) => Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );
}
