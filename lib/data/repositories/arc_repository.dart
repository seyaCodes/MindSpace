import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArcRepository {
  // ignore: unused_field
  final SupabaseClient _client;

  ArcRepository(this._client);
}

final arcRepositoryProvider = Provider<ArcRepository>(
  (ref) => ArcRepository(Supabase.instance.client),
);
