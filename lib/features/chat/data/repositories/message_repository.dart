import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/message_model.dart';

class MessageRepository {
  final SupabaseClient _client;

  MessageRepository(this._client);

  Future<List<MessageModel>> getMessages(String chatId) async {
    final result = await _client
        .from('messages')
        .select()
        .eq('chat_id', chatId)
        .order('created_at', ascending: true);

    return (result as List).map((e) => MessageModel.fromJson(e)).toList();
  }

  Future<MessageModel> createMessage({
    required String chatId,
    required String role,
    required String content,
  }) async {
    final result = await _client.from('messages').insert({
      'chat_id': chatId,
      'role': role,
      'content': content,
    }).select().single();

    return MessageModel.fromJson(result);
  }
}

final messageRepositoryProvider = Provider<MessageRepository>(
  (ref) => MessageRepository(Supabase.instance.client),
);
