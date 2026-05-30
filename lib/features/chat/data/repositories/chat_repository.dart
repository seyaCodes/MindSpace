import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);
}

final chatRepositoryProvider =
    Provider<ChatRepository>(
  (ref) => ChatRepository(
    Supabase.instance.client,
  ),
);