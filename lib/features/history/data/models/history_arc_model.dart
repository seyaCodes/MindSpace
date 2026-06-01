import '../../domain/entities/history_arc.dart';

class HistoryArcModel extends HistoryArc {
  const HistoryArcModel({
    required super.id,
    required super.name,
    required super.status,
    required super.sessionCount,
    required super.createdAt,
    super.archivedAt,
    super.latestInsight,
  });

  factory HistoryArcModel.fromJson(Map<String, dynamic> json) {
    return HistoryArcModel(
      id: json['id'] as String,
      name: (json['name'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'active',
      sessionCount: (json['session_count'] as int?) ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      archivedAt: json['archived_at'] != null
          ? DateTime.parse(json['archived_at'] as String)
          : null,
      latestInsight: null,
    );
  }
}
