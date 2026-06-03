import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/history_arc_model.dart';
import '../models/history_reflection_model.dart';
import '../repositories/history_repository.dart';

final historyTimelineProvider =
    FutureProvider.autoDispose<List<HistoryReflectionModel>>((ref) async {
  return ref.read(historyRepositoryProvider).getTimeline();
});

final historyActiveArcsProvider =
    FutureProvider.autoDispose<List<HistoryArcModel>>((ref) async {
  return ref.read(historyRepositoryProvider).getActiveArcs();
});

final historyArchivedArcsProvider =
    FutureProvider.autoDispose<List<HistoryArcModel>>((ref) async {
  return ref.read(historyRepositoryProvider).getArchivedArcs();
});
