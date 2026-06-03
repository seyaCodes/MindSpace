import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/arc_repository.dart';

final arcsProvider = FutureProvider.autoDispose<List<ArcModel>>((ref) async {
  return ref.read(arcRepositoryProvider).getArcs();
});

final arcProvider =
    FutureProvider.family<ArcModel?, String>((ref, id) async {
  return ref.read(arcRepositoryProvider).getArc(id);
});

final arcInsightsByArcProvider =
    FutureProvider.family<List<dynamic>, String>((ref, arcId) async {
  return ref.read(arcRepositoryProvider).getInsights(arcId);
});
