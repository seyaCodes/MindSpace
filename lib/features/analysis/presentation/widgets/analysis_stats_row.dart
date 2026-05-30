import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/analysis_providers.dart';

class AnalysisStatsRow extends ConsumerWidget {
  const AnalysisStatsRow({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final stats = ref.watch(analysisStatsProvider);

    return stats.when(
      data: (data) {
        return Row(
          children: [
            Expanded(
              child: _StatCard(
                value: '${data['sessions'] ?? 0}',
                label: 'SESSIONS',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                value: '${data['arcs'] ?? 0}',
                label: 'ACTIVE ARCS',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                value: '${data['streak'] ?? 0}',
                label: 'DAYS STREAK',
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 130,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
  Text(
    value,
    style: const TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
    ),
  ),
  Text(
    label,
    maxLines: 2,
    textAlign: TextAlign.center,
  ),
]
      ),
    );
  }
}
