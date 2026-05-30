import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../chat/domain/models/message_model.dart';

class SessionRepository {
  final SupabaseClient _client;

  SessionRepository(this._client);

  Future<List<MessageModel>> getMessages(String threadId) async {
    final result = await _client
        .from('messages')
        .select()
        .eq('thread_id', threadId)
        .order('created_at', ascending: true);

    return (result as List).map((e) => MessageModel.fromJson(e)).toList();
  }

  Future<void> createMessage({
    required String threadId,
    required String role,
    required String content,
  }) async {
    await _client.from('messages').insert({
      'thread_id': threadId,
      'role': role,
      'content': content,
    });
  }
}

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(Supabase.instance.client),
);
