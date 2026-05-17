import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatProvider extends Notifier<void> {
  @override
  void build() {}

  void wrapUp() {}
}

final chatProvider = NotifierProvider<ChatProvider, void>(ChatProvider.new);
