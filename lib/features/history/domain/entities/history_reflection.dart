class HistoryReflection {
  final String id;
  final String arcId;
  final String? arcName;
  final String title;
  final String summary;
  final DateTime createdAt;

  const HistoryReflection({
    required this.id,
    required this.arcId,
    this.arcName,
    required this.title,
    required this.summary,
    required this.createdAt,
  });
}
