import '../../domain/entities/history_reflection.dart';

class HistoryReflectionModel extends HistoryReflection {
  const HistoryReflectionModel({
    required super.id,
    required super.arcId,
    super.arcName,
    required super.title,
    required super.summary,
    required super.createdAt,
  });

  factory HistoryReflectionModel.fromJson(Map<String, dynamic> json) {
    final arcsMap = json['arcs'] as Map<String, dynamic>?;
    return HistoryReflectionModel(
      id: json['id'] as String,
      arcId: json['arc_id'] as String? ?? '',
      arcName: arcsMap?['name'] as String?,
      title: json['question_to_sit_with'] as String? ?? '',
      summary: json['what_sage_heard'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
