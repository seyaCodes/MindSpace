import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/chat_model.dart';
import '../../domain/models/message_model.dart';
import '../repositories/chat_repository.dart';
import '../repositories/message_repository.dart';

final chatsProvider = FutureProvider<List<ChatModel>>((ref) async {
  return ref.read(chatRepositoryProvider).getChats();
});

final messagesProvider =
    FutureProvider.family<List<MessageModel>, String>((ref, chatId) async {
  return ref.read(messageRepositoryProvider).getMessages(chatId);
});
