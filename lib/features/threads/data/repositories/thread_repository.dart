import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/thread_model.dart';

class ThreadRepository {
  final SupabaseClient _client;

  ThreadRepository(this._client);

  Future<List<ThreadModel>> getThreads() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final result = await _client
        .from('threads')
        .select()
        .eq('user_id', user.id)
        .order('last_message_at', ascending: false);

    return (result as List).map((e) => ThreadModel.fromJson(e)).toList();
  }

  Future<void> archiveThread(String id) async {
    await _client
        .from('threads')
        .update({'status': 'archived'}).eq('id', id);
  }

  Future<void> renameThread(String id, String title) async {
    await _client
        .from('threads')
        .update({'title': title}).eq('id', id);
  }
}

final threadRepositoryProvider = Provider<ThreadRepository>(
  (ref) => ThreadRepository(Supabase.instance.client),
);
