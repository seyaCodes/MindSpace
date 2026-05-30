import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/analysis_repository.dart';

final analysisStatsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.read(analysisRepositoryProvider).getStats();
});

final heatmapProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.read(analysisRepositoryProvider).getHeatmap();
});

final arcInsightsProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.read(analysisRepositoryProvider).getArcInsights();
});
