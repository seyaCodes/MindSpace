import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalysisRepository {
  final SupabaseClient _client;

  AnalysisRepository(this._client);

  Future<Map<String, dynamic>> getStats() async {
    final user = _client.auth.currentUser;
    if (user == null) return {'sessions': 0, 'arcs': 0, 'streak': 0};

    final chats = await _client
        .from('chats')
        .select('id')
        .eq('user_id', user.id);

    final arcs = await _client
        .from('arcs')
        .select('id')
        .eq('user_id', user.id)
        .eq('status', 'active');

    return {
      'sessions': (chats as List).length,
      'arcs': (arcs as List).length,
      'streak': 0,
    };
  }

  Future<List<dynamic>> getHeatmap() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    return await _client
        .from('reflections')
        .select('created_at')
        .eq('user_id', user.id);
  }

  Future<List<dynamic>> getArcInsights() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    return await _client
        .from('arc_insights')
        .select()
        .eq('user_id', user.id)
        .order('generated_at', ascending: false);
  }
}

final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) => AnalysisRepository(Supabase.instance.client),
);
