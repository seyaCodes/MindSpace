import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repositories/arc_repository.dart';
import '../data/repositories/reflection_repository.dart';
import '../features/chat/data/repositories/message_repository.dart';

class ChatPipelineService {
  final ArcRepository _arcRepository;
  final ReflectionRepository _reflectionRepository;
  final MessageRepository _messageRepository;

  ChatPipelineService(
    this._arcRepository,
    this._reflectionRepository,
    this._messageRepository,
  );

  /// Called after the FIRST user message.
  /// Creates/gets an Arc, creates a Reflection,
  /// updates Arc session count.
  Future<void> processFirstMessage({
    required String chatId,
  }) async {
    try {
      final userId =
          Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('No authenticated user');
      }

      debugPrint('[Pipeline] Starting first message flow');

      final arc =
          await _arcRepository.getOrCreateActiveArc(userId);

      debugPrint('[Pipeline] Arc ready: ${arc.id}');

      await _reflectionRepository.createReflection(
        chatId: chatId,
        userId: userId,
        arcId: arc.id,
        whatSageHeard:
            'Reflection placeholder until AI integration.',
        questionToSitWith:
            'What feels most important about this moment?',
        sharedPerspective:
            'AI integration will replace this.',
      );

      debugPrint('[Pipeline] Reflection created');

      await _arcRepository.incrementSessionCount(
        arc.id,
      );

      debugPrint('[Pipeline] Arc updated');
      debugPrint('[Pipeline] Complete');
    } catch (e, stackTrace) {
      debugPrint(
        '[Pipeline] ERROR: $e\n$stackTrace',
      );

      rethrow;
    }
  }

  /// Future AI entry point.
  /// Keep this for later AI integration.
  Future<void> processUserMessage({
    required String chatId,
    required String userId,
    required String content,
  }) async {
    debugPrint(
      '[Pipeline] processUserMessage() not implemented yet',
    );
  }
}

final chatPipelineServiceProvider =
    Provider<ChatPipelineService>((ref) {
  return ChatPipelineService(
    ref.read(arcRepositoryProvider),
    ref.read(reflectionRepositoryProvider),
    ref.read(messageRepositoryProvider),
  );
});