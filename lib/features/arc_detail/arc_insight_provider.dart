import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArcInsightProvider extends Notifier<void> {
  @override
  void build() {}
}

final arcInsightProvider =
    NotifierProvider<ArcInsightProvider, void>(ArcInsightProvider.new);
