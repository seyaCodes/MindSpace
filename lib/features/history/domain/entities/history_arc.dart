class HistoryArc {
  final String id;
  final String name;
  final String status;
  final int sessionCount;
  final DateTime createdAt;
  final DateTime? archivedAt;
  final String? latestInsight;

  const HistoryArc({
    required this.id,
    required this.name,
    required this.status,
    required this.sessionCount,
    required this.createdAt,
    this.archivedAt,
    this.latestInsight,
  });
}
