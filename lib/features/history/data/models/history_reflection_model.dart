import '../../domain/entities/history_reflection.dart';

class HistoryReflectionModel extends HistoryReflection {
  const HistoryReflectionModel({
    required super.id,
    required super.arcId,
    required super.title,
    required super.summary,
    required super.createdAt,
  });

  factory HistoryReflectionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return HistoryReflectionModel(
      id: json['id'],
      arcId: json['arc_id'] as String? ?? '',
      title: json['question_to_sit_with'] ?? '',
      summary: json['what_sage_heard'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'],
      ),
    );
  }
}
