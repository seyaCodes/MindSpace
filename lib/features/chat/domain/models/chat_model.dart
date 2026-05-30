class ChatModel {
  final String id;
  final String userId;
  final String? arcId;
  final String status;
  final DateTime createdAt;
  final int? sessionNumber;

  const ChatModel({
    required this.id,
    required this.userId,
    this.arcId,
    required this.status,
    required this.createdAt,
    this.sessionNumber,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      arcId: json['arc_id'] as String?,
      status: (json['status'] as String?) ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
      sessionNumber: json['session_number'] as int?,
    );
  }
}
