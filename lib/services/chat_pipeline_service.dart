import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repositories/arc_repository.dart';
import '../data/repositories/reflection_repository.dart';
import 'llm_service.dart';

class ChatPipelineService {
  final ArcRepository _arcRepository;
  final ReflectionRepository _reflectionRepository;
  final LlmService _llmService;

  ChatPipelineService(
    this._arcRepository,
    this._reflectionRepository,
    this._llmService,
  );

  /// Called on Wrap Up and on back-navigation after at least one message.
  ///
  /// Throws on any unrecoverable failure so the caller can surface it to the user.
  /// Arc-assignment failure is non-fatal (reflection is already saved).
  Future<void> wrapUpSession({required String chatId}) async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    debugPrint('[Pipeline] ── wrapUpSession start ── chat=$chatId user=$userId');

    // ── Step 1: generate reflection ────────────────────────────────
    final reflectionResult = await _llmService.generateReflection(chatId: chatId);
    debugPrint('[Pipeline] reflection generated: '
        'heard=${reflectionResult.whatSageHeard.length}chars');

    // ── Step 2: persist reflection to DB ──────────────────────────
    final savedReflection = await _reflectionRepository.createReflection(
      chatId: chatId,
      userId: userId,
      whatSageHeard: reflectionResult.whatSageHeard,
      questionToSitWith: reflectionResult.questionToSitWith,
      sharedPerspective: reflectionResult.sharedPerspective,
    );
    debugPrint('[Pipeline] reflection saved: id=${savedReflection.id}');

    // ── Step 3: arc assignment (non-fatal if it fails) ─────────────
    // assign-arc handles writing chat.arc_id and reflection.arc_id itself,
    // so we only need to call incrementSessionCount after it succeeds.
    try {
      final arcResult = await _llmService.assignArc(
        chatId: chatId,
        reflectionId: savedReflection.id,
      );
      debugPrint('[Pipeline] arc assigned: '
          'id=${arcResult.arcId} isNew=${arcResult.isNew} name=${arcResult.arcName}');

      // Increment session count on the assigned arc.
      await _arcRepository.incrementSessionCount(arcResult.arcId);
      debugPrint('[Pipeline] session count incremented for arc=${arcResult.arcId}');

      debugPrint('[Pipeline] ── wrapUpSession complete ──');
    } on Exception catch (e, st) {
      // Arc assignment is a best-effort operation.
      // The reflection is already saved — the user's session is not lost.
      debugPrint('[Pipeline] arc assignment FAILED (non-fatal): $e');
      debugPrint('[Pipeline] stack trace: $st');
      // Do NOT rethrow — wrap-up is considered successful.
    }
  }
}

final chatPipelineServiceProvider = Provider<ChatPipelineService>((ref) {
  return ChatPipelineService(
    ref.read(arcRepositoryProvider),
    ref.read(reflectionRepositoryProvider),
    ref.read(llmServiceProvider),
  );
});
