import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReflectionProvider extends Notifier<void> {
  @override
  void build() {}
}

final reflectionProvider =
    NotifierProvider<ReflectionProvider, void>(ReflectionProvider.new);
