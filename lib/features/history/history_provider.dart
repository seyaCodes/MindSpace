import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryState {
  final int selectedTab;
  final bool archivedExpanded;
  final String selectedFilter;

  const HistoryState({
    this.selectedTab = 0,
    this.archivedExpanded = false,
    this.selectedFilter = 'All',
  });

  HistoryState copyWith({
    int? selectedTab,
    bool? archivedExpanded,
    String? selectedFilter,
  }) {
    return HistoryState(
      selectedTab: selectedTab ?? this.selectedTab,
      archivedExpanded: archivedExpanded ?? this.archivedExpanded,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier() : super(const HistoryState());

  void setTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  void toggleArchived() {
    state = state.copyWith(archivedExpanded: !state.archivedExpanded);
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier();
});