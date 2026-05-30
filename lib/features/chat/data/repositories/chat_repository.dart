import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/chat_model.dart';

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);

  Future<ChatModel> createChat() async {
    final user = _client.auth.currentUser!;
    final result = await _client.from('chats').insert({
      'user_id': user.id,
      'status': 'active',
    }).select().single();
    return ChatModel.fromJson(result);
  }

  Future<List<ChatModel>> getChats() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final result = await _client
        .from('chats')
        .select()
        .eq('user_id', user.id)
        .eq('status', 'active')
        .order('created_at', ascending: false);

    return (result as List).map((e) => ChatModel.fromJson(e)).toList();
  }

  Future<ChatModel?> getChat(String id) async {
    final result = await _client
        .from('chats')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (result == null) return null;
    return ChatModel.fromJson(result);
  }

  Future<void> archiveChat(String id) async {
    await _client
        .from('chats')
        .update({'status': 'archived'}).eq('id', id);
  }
}

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(Supabase.instance.client),
);
