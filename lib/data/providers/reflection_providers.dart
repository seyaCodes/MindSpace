import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/reflection_repository.dart';

final reflectionProvider =
    FutureProvider.family<ReflectionModel?, String>((ref, id) async {
  return ref.read(reflectionRepositoryProvider).getReflection(id);
});

final reflectionsByArcProvider =
    FutureProvider.family<List<ReflectionModel>, String>((ref, arcId) async {
  return ref.read(reflectionRepositoryProvider).getReflectionsByArc(arcId);
});
