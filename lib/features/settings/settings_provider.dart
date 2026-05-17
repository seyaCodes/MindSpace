import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsProvider extends Notifier<void> {
  @override
  void build() {}
}

final settingsProvider =
    NotifierProvider<SettingsProvider, void>(SettingsProvider.new);
