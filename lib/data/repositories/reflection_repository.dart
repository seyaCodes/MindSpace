import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReflectionModel {
  final String id;
  final String chatId;
  final String userId;
  final String? arcId;
  final String? spiritId;
  final String whatSageHeard;
  final String questionToSitWith;
  final String? sharedPerspective;
  final String? sessionTone;
  final DateTime createdAt;

  const ReflectionModel({
    required this.id,
    required this.chatId,
    required this.userId,
    this.arcId,
    this.spiritId,
    required this.whatSageHeard,
    required this.questionToSitWith,
    this.sharedPerspective,
    this.sessionTone,
    required this.createdAt,
  });

  factory ReflectionModel.fromJson(Map<String, dynamic> json) {
    return ReflectionModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      userId: json['user_id'] as String,
      arcId: json['arc_id'] as String?,
      spiritId: json['spirit_id'] as String?,
      whatSageHeard: (json['what_sage_heard'] as String?) ?? '',
      questionToSitWith: (json['question_to_sit_with'] as String?) ?? '',
      sharedPerspective: json['shared_perspective'] as String?,
      sessionTone: json['session_tone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class ReflectionRepository {
  final SupabaseClient _client;

  ReflectionRepository(this._client);

  Future<ReflectionModel> createReflection({
    required String chatId,
    required String userId,
    String? arcId,
    required String whatSageHeard,
    required String questionToSitWith,
    String? sharedPerspective,
  }) async {
    final result = await _client.from('reflections').insert({
      'chat_id': chatId,
      'user_id': userId,
      if (arcId != null) 'arc_id': arcId,
      'what_sage_heard': whatSageHeard,
      'question_to_sit_with': questionToSitWith,
      if (sharedPerspective != null) 'shared_perspective': sharedPerspective,
    }).select().single();

    return ReflectionModel.fromJson(result);
  }

  Future<ReflectionModel?> getReflection(String id) async {
    final result = await _client
        .from('reflections')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (result == null) return null;
    return ReflectionModel.fromJson(result);
  }

  Future<List<ReflectionModel>> getReflectionsByArc(String arcId) async {
    final result = await _client
        .from('reflections')
        .select()
        .eq('arc_id', arcId)
        .order('created_at', ascending: false);

    return (result as List).map((e) => ReflectionModel.fromJson(e)).toList();
  }
}

final reflectionRepositoryProvider = Provider<ReflectionRepository>(
  (ref) => ReflectionRepository(Supabase.instance.client),
);
