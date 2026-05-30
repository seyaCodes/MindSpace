class SessionModel {
  final String id;
  final String userId;
  final String? arcId;
  final String? title;
  final DateTime createdAt;

  const SessionModel({
    required this.id,
    required this.userId,
    this.arcId,
    this.title,
    required this.createdAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      arcId: json['arc_id'] as String?,
      title: json['title'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
