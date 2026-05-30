class MessageModel {
  final String id;
  final String role;
  final String content;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });
}