class Message {
  final String id;
  final String chatId;
  final String userId;
  final String role;
  final String content;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.role,
    required this.content,
    required this.createdAt,
  });
}
