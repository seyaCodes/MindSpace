import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReflectionRepository {
  // ignore: unused_field
  final SupabaseClient _client;

  ReflectionRepository(this._client);
}

final reflectionRepositoryProvider = Provider<ReflectionRepository>(
  (ref) => ReflectionRepository(Supabase.instance.client),
);
