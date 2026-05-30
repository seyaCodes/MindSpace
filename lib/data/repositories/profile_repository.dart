import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileModel {
  final String id;
  final String? displayName;
  final bool onboardingCompleted;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    required this.displayName,
    required this.onboardingCompleted,
    required this.createdAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      displayName: map['display_name'] as String?,
      onboardingCompleted: (map['onboarding_completed'] as bool?) ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

  Future<ProfileModel?> fetchProfile(String userId) async {
    final response =
        await _client.from('profiles').select().eq('id', userId).maybeSingle();

    if (response == null) return null;
    return ProfileModel.fromMap(response);
  }

  Future<void> upsertDisplayName({
    required String userId,
    required String displayName,
  }) async {
    await _client.from('profiles').upsert({
      'id': userId,
      'display_name': displayName,
    });
  }

  Future<void> markOnboardingComplete(String userId) async {
    await _client.from('profiles').update({
      'onboarding_completed': true,
    }).eq('id', userId);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(Supabase.instance.client);
});
