import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArcDetailProvider extends Notifier<void> {
  @override
  void build() {}
}

final arcDetailProvider =
    NotifierProvider<ArcDetailProvider, void>(ArcDetailProvider.new);
