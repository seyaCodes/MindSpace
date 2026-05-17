import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'history_provider.dart';
import 'widgets/search_bar.dart';
import 'widgets/emotion_filter_chips.dart';
import 'widgets/timeline_session_card.dart';

class TimelineTab extends ConsumerWidget {
  const TimelineTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(historyProvider).selectedFilter;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        const HistorySearchBar(),
        const SizedBox(height: 16),
        EmotionFilterChips(
          selected: selectedFilter,
          onChanged: (f) =>
              ref.read(historyProvider.notifier).setFilter(f),
        ),
        const SizedBox(height: 24),

        // Day section header
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF6C5CE7),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'TODAY, APR 25 · 2 SESSIONS',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9B9BA0),
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        GestureDetector(
          onTap: () => context.push('/arc/1'),
          behavior: HitTestBehavior.opaque,
          child: const TimelineSessionCard(
            arcColor: Color(0xFF6C5CE7),
            arcName: 'THE JOB HUNT',
            arcTitle: 'The Job Hunt',
            arcTitleHighlight: 'Hunt',
            time: '7:30 PM · 14 min',
            quote:
                '"Realized the pressure isn\'t about the job itself — it\'s about the fear of being seen as not enough."',
            showViewReflection: true,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => context.push('/arc/1'),
          behavior: HitTestBehavior.opaque,
          child: const TimelineSessionCard(
            arcColor: Color(0xFF00C48C),
            arcName: 'THE JOB HUNT',
            arcTitle: 'The Job Hunt',
            arcTitleHighlight: 'Hunt',
            highlightColor: Color(0xFF00C48C),
            time: '9:15 AM · 5 min',
            quote:
                '"A brief morning check-in to clear the mind before a big day. Found a quiet kind of"',
            showViewReflection: false,
          ),
        ),
      ],
    );
  }
}