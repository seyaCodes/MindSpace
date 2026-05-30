class ThreadModel {
  final String id;
  final String userId;
  final String? title;
  final int messageCount;
  final DateTime createdAt;
  final DateTime? lastMessageAt;

  const ThreadModel({
    required this.id,
    required this.userId,
    this.title,
    required this.messageCount,
    required this.createdAt,
    this.lastMessageAt,
  });

  factory ThreadModel.fromJson(Map<String, dynamic> json) {
    return ThreadModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String?,
      messageCount: (json['message_count'] as int?) ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
    );
  }
}
