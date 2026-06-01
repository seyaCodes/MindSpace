import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArcModel {
  final String id;
  final String userId;
  final String name;
  final String status;
  final int sessionCount;
  final DateTime? lastSessionAt;
  final DateTime createdAt;
  final bool userRenamed;

  const ArcModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.status,
    required this.sessionCount,
    this.lastSessionAt,
    required this.createdAt,
    required this.userRenamed,
  });

  factory ArcModel.fromJson(Map<String, dynamic> json) {
    return ArcModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: (json['name'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'active',
      sessionCount: (json['session_count'] as int?) ?? 0,
      lastSessionAt: json['last_session_at'] != null
          ? DateTime.parse(json['last_session_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      userRenamed: (json['user_renamed'] as bool?) ?? false,
    );
  }
}

class ArcRepository {
  final SupabaseClient _client;

  ArcRepository(this._client);

  Future<List<ArcModel>> getArcs() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final result = await _client
        .from('arcs')
        .select()
        .eq('user_id', user.id)
        .eq('status', 'active')
        .order('last_session_at', ascending: false);

    return (result as List)
        .map((e) => ArcModel.fromJson(e))
        .toList();
  }

  Future<ArcModel?> getArc(String id) async {
    final result = await _client
        .from('arcs')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (result == null) return null;
    return ArcModel.fromJson(result);
  }

  Future<void> renameArc(String id, String name) async {
    await _client.from('arcs').update({
      'name': name,
      'user_renamed': true,
    }).eq('id', id);
  }

  Future<void> archiveArc(String id) async {
    await _client.from('arcs').update({
      'status': 'archived',
      'archived_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', id);
  }

  Future<ArcModel> createArc({
    required String userId,
    required String name,
  }) async {
    final result = await _client
        .from('arcs')
        .insert({
          'user_id': userId,
          'name': name,
          'status': 'active',
          'session_count': 0,
          'user_renamed': false,
        })
        .select()
        .single();

    return ArcModel.fromJson(result);
  }

  // ─────────────────────────────────────────────
  // GENERATE ARC INSIGHT (DEBUG VERSION)
  // ─────────────────────────────────────────────

  Future<void> generateInsight(String arcId) async {
    print('[ARC] calling generate-arc-insight for $arcId');

    try {
      final res = await _client.functions.invoke(
        'generate-arc-insight',
        body: {'arc_id': arcId},
      );

      print('[ARC] status: ${res.status}');
      print('[ARC] data: ${res.data}');

      if (res.status != 200) {
        throw Exception(
          'generate-arc-insight failed '
          'status=${res.status} '
          'data=${res.data}',
        );
      }
    } catch (e, st) {
      print('[ARC] invoke ERROR: $e');
      print(st);
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  // GET INSIGHTS
  // ─────────────────────────────────────────────

  // Only reads — never triggers generation. Use this everywhere except the analysis screen.
  Future<List<dynamic>> getExistingInsights(String arcId) async {
    print('[ARC] getExistingInsights for $arcId');
    try {
      final result = await _client
          .from('arc_insights')
          .select()
          .eq('arc_id', arcId)
          .order('generated_at', ascending: false)
          .timeout(const Duration(seconds: 15));
      print('[ARC] getExistingInsights found: ${(result as List).length}');
      return result;
    } catch (e) {
      print('[ARC] getExistingInsights ERROR: $e');
      return [];
    }
  }

  // Reads existing insights; if none found, triggers generation. Only call from analysis screen.
  Future<List<dynamic>> getInsights(String arcId) async {
    print('[ARC] getInsights start for $arcId');

    final List<dynamic> existing;
    try {
      existing = await _client
          .from('arc_insights')
          .select()
          .eq('arc_id', arcId)
          .order('generated_at', ascending: false)
          .timeout(const Duration(seconds: 15));
      print('[ARC] existing query returned ${existing.length} rows');
    } catch (e) {
      print('[ARC] arc_insights SELECT ERROR: $e');
      rethrow;
    }

    if (existing.isNotEmpty) {
      print('[ARC] returning ${existing.length} existing insights');
      return existing;
    }

    print('[ARC] no insights → calling generate-arc-insight');
    await generateInsight(arcId);
    print('[ARC] generation call returned OK');

    try {
      final fresh = await _client
          .from('arc_insights')
          .select()
          .eq('arc_id', arcId)
          .order('generated_at', ascending: false)
          .timeout(const Duration(seconds: 15));
      print('[ARC] fresh insights count: ${(fresh as List).length}');
      return fresh;
    } catch (e) {
      print('[ARC] fresh SELECT ERROR after generation: $e');
      rethrow;
    }
  }

  Future<void> incrementSessionCount(String arcId) async {
    final arc = await getArc(arcId);
    if (arc == null) {
      throw Exception('Arc not found: $arcId');
    }

    await _client.from('arcs').update({
      'session_count': arc.sessionCount + 1,
      'last_session_at':
          DateTime.now().toUtc().toIso8601String(),
    }).eq('id', arcId);
  }

  Future<void> deleteArc(String id) async {
    await _client.from('arcs').delete().eq('id', id);
  }

  Future<void> reviveArc(String id) async {
    await _client.from('arcs').update({
      'status': 'active',
      'archived_at': null,
    }).eq('id', id);
  }

  Future<ArcModel> getOrCreateActiveArc(String userId) async {
    final arcs = await getArcs();

    if (arcs.isNotEmpty) {
      return arcs.first;
    }

    return createArc(
      userId: userId,
      name: 'My Journey',
    );
  }
}

final arcRepositoryProvider = Provider<ArcRepository>(
  (ref) => ArcRepository(Supabase.instance.client),
);