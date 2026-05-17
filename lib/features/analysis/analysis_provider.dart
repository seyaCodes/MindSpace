import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisProvider extends Notifier<void> {
  @override
  void build() {}
}

final analysisProvider =
    NotifierProvider<AnalysisProvider, void>(AnalysisProvider.new);
