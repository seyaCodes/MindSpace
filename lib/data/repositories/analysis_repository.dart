import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalysisRepository {
  // ignore: unused_field
  final SupabaseClient _client;

  AnalysisRepository(this._client);
}

final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) => AnalysisRepository(Supabase.instance.client),
);
