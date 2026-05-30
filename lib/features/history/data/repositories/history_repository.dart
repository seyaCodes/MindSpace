import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/history_arc_model.dart';
import '../models/history_reflection_model.dart';

class HistoryRepository {
  final SupabaseClient client;

  HistoryRepository(this.client);

  Future<List<HistoryArcModel>> getActiveArcs() async {
    final user = client.auth.currentUser;
    if (user == null) return [];

    final result = await client
        .from('arcs')
        .select()
        .eq('user_id', user.id)
        .eq('status', 'active')
        .order('last_session_at', ascending: false);

    return (result as List).map((e) => HistoryArcModel.fromJson(e)).toList();
  }

  Future<List<HistoryArcModel>> getArchivedArcs() async {
    final user = client.auth.currentUser;
    if (user == null) return [];

    final result = await client
        .from('arcs')
        .select()
        .eq('user_id', user.id)
        .eq('status', 'archived')
        .order('archived_at', ascending: false);

    return (result as List).map((e) => HistoryArcModel.fromJson(e)).toList();
  }

  Future<List<HistoryReflectionModel>> getTimeline() async {
    final user = client.auth.currentUser;
    if (user == null) return [];

    final result = await client
        .from('reflections')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (result as List).map((e) => HistoryReflectionModel.fromJson(e)).toList();
  }

  Future<HistoryArcModel?> getArc(String id) async {
    final result = await client
        .from('arcs')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (result == null) return null;
    return HistoryArcModel.fromJson(result);
  }

  Future<HistoryReflectionModel?> getSession(String id) async {
    final result = await client
        .from('reflections')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (result == null) return null;
    return HistoryReflectionModel.fromJson(result);
  }
}

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepository(Supabase.instance.client),
);
