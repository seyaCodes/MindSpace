import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalysisRepository {
  final SupabaseClient _client;

  AnalysisRepository(this._client);

  Future<Map<String, dynamic>> getStats() async {
    final user = _client.auth.currentUser;
    if (user == null) return {'sessions': 0, 'arcs': 0, 'streak': 0};

    final chats = await _client
        .from('reflections')
        .select('id, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    final arcs = await _client
        .from('arcs')
        .select('id')
        .eq('user_id', user.id)
        .eq('status', 'active');

    final streak = _calculateStreak(chats as List);

    return {
      'sessions': (chats).length,
      'arcs': (arcs as List).length,
      'streak': streak,
    };
  }

  int _calculateStreak(List<dynamic> reflections) {
    if (reflections.isEmpty) return 0;

    final dates = reflections
        .map((r) {
          final dt = DateTime.parse(r['created_at'] as String).toLocal();
          return DateTime(dt.year, dt.month, dt.day);
        })
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final yesterdayNorm = todayNorm.subtract(const Duration(days: 1));

    if (dates.first != todayNorm && dates.first != yesterdayNorm) return 0;

    int streak = 1;
    for (int i = 1; i < dates.length; i++) {
      final expected = dates[i - 1].subtract(const Duration(days: 1));
      if (dates[i] == expected) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
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
        .select('*, arcs(id, name, session_count, status)')
        .eq('user_id', user.id)
        .order('generated_at', ascending: false);
  }
}

final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) => AnalysisRepository(Supabase.instance.client),
);
