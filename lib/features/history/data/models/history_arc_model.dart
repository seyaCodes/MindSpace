import '../../domain/entities/history_arc.dart';

class HistoryArcModel extends HistoryArc {
  const HistoryArcModel({
    required super.id,
    required super.name,
    required super.status,
    required super.sessionCount,
  });

  factory HistoryArcModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return HistoryArcModel(
      id: json['id'],
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      sessionCount: json['session_count'] ?? 0,
    );
  }
}
