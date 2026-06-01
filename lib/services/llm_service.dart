import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

// ── Result models ──────────────────────────────────────────────

class ReflectionResult {
  final String whatSageHeard;
  final String questionToSitWith;
  final String sharedPerspective;
  final String? spiritId;

  const ReflectionResult({
    required this.whatSageHeard,
    required this.questionToSitWith,
    required this.sharedPerspective,
    this.spiritId,
  });

  factory ReflectionResult.fromJson(Map<String, dynamic> json) {
    return ReflectionResult(
      whatSageHeard: json['what_sage_heard'] as String? ?? '',
      questionToSitWith: json['question_to_sit_with'] as String? ?? '',
      sharedPerspective: json['shared_perspective'] as String? ?? '',
      spiritId: json['spirit_id'] as String?,
    );
  }
}

class ArcAssignmentResult {
  final String arcId;
  final bool isNew;
  final String? arcName;

  const ArcAssignmentResult({
    required this.arcId,
    required this.isNew,
    this.arcName,
  });

  factory ArcAssignmentResult.fromJson(Map<String, dynamic> json) {
    return ArcAssignmentResult(
      arcId: json['arc_id'] as String? ?? '',
      isNew: json['is_new'] as bool? ?? false,
      arcName: json['arc_name'] as String?,
    );
  }
}

// ── Service ────────────────────────────────────────────────────

class LlmService {
  final SupabaseClient _client;

  LlmService(this._client);

String get _baseUrl => 'https://fmcaqiriafmjempcirzi.supabase.co';
  String get _accessToken =>
      _client.auth.currentSession?.accessToken ?? '';

  /// Streams Sage's reply token by token.
  /// The Edge Function also saves both user + assistant messages.
  Stream<String> streamChat({
    required String chatId,
    required String content,
  }) async* {
    final url = Uri.parse('$_baseUrl/functions/v1/chat-stream');

    final request = http.Request('POST', url);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $_accessToken';
    request.body = jsonEncode({
      'chat_id': chatId,
      'message': content,
    });

    final response = await http.Client().send(request);

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      debugPrint('[LlmService] chat-stream error: $body');
      throw Exception('chat-stream failed: ${response.statusCode}');
    }

    // Parse SSE stream
    String buffer = '';

   await for (final chunk in response.stream.transform(utf8.decoder)) {
      buffer += chunk;
      // Process complete SSE lines
      while (buffer.contains('\n')) {
        final lineEnd = buffer.indexOf('\n');
        final line = buffer.substring(0, lineEnd).trim();
        buffer = buffer.substring(lineEnd + 1);

        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();

          if (data == '[DONE]') return;

          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            final choices = json['choices'] as List<dynamic>?;
            String token = '';
            if (choices != null && choices.isNotEmpty) {
              final delta = (choices[0] as Map<String, dynamic>)['delta'] as Map<String, dynamic>?;
              token = delta?['content'] as String? ?? '';
            }
            if (token.isNotEmpty) {
              yield token;
            }
          } catch (_) {
            // Not valid JSON, might be a partial token
            if (data.isNotEmpty && data != '[DONE]') {
              yield data;
            }
          }
        }
      }
    }

    // Process any remaining buffer
    if (buffer.trim().isNotEmpty) {
      final line = buffer.trim();
      if (line.startsWith('data: ')) {
        final data = line.substring(6).trim();
        if (data != '[DONE]' && data.isNotEmpty) {
          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            final choices = json['choices'] as List<dynamic>?;
            String token = '';
            if (choices != null && choices.isNotEmpty) {
              final delta = (choices[0] as Map<String, dynamic>)['delta'] as Map<String, dynamic>?;
              token = delta?['content'] as String? ?? '';
            }
            if (token.isNotEmpty) yield token;
            if (token.isNotEmpty) yield token;
          } catch (_) {
            yield data;
          }
        }
      }
    }
  }

  /// Calls end-chat to generate a structured reflection.
  Future<ReflectionResult> generateReflection({
    required String chatId,
  }) async {
    debugPrint('[LlmService] calling end-chat for chat=$chatId');
    // functions.invoke throws FunctionsException on HTTP 4xx/5xx.
    final response = await _client.functions.invoke(
      'end-chat',
      body: {'chat_id': chatId},
    );

    debugPrint('[LlmService] end-chat status OK, data=${response.data}');

    if (response.data == null) {
      throw Exception('end-chat returned null data');
    }

    return ReflectionResult.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  /// Calls assign-arc to cluster the session into an arc.
  Future<ArcAssignmentResult> assignArc({
    required String chatId,
    required String reflectionId,
  }) async {
    debugPrint('[LlmService] calling assign-arc for chat=$chatId reflection=$reflectionId');
    // functions.invoke throws FunctionsException on HTTP 4xx/5xx.
    final response = await _client.functions.invoke(
      'assign-arc',
      body: {
        'chat_id': chatId,
        'reflection_id': reflectionId,
      },
    );

    debugPrint('[LlmService] assign-arc status OK, data=${response.data}');

    if (response.data == null) {
      throw Exception('assign-arc returned null data');
    }

    final result = ArcAssignmentResult.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );

    if (result.arcId.isEmpty) {
      throw Exception(
        'assign-arc returned empty arc_id — check edge function logs in Supabase dashboard',
      );
    }

    debugPrint('[LlmService] arc assigned: id=${result.arcId} isNew=${result.isNew}');
    return result;
  }
}

final llmServiceProvider = Provider<LlmService>(
  (ref) => LlmService(Supabase.instance.client),
);