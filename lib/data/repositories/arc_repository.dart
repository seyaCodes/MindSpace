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

    return (result as List).map((e) => ArcModel.fromJson(e)).toList();
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
    final result = await _client.from('arcs').insert({
      'user_id': userId,
      'name': name,
      'status': 'active',
      'session_count': 0,
      'user_renamed': false,
    }).select().single();
    return ArcModel.fromJson(result);
  }

  Future<List<dynamic>> getInsights(String arcId) async {
    return await _client
        .from('arc_insights')
        .select()
        .eq('arc_id', arcId)
        .order('generated_at', ascending: false);
  }

  Future<void> incrementSessionCount(String arcId) async {
    final arc = await getArc(arcId);

    if (arc == null) {
      throw Exception('Arc not found: $arcId');
    }

    await _client
        .from('arcs')
        .update({
          'session_count': arc.sessionCount + 1,
          'last_session_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', arcId);
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