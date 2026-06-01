import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/router/app_router.dart';

// ── Provider ─────────────────────────────────────────────────────────────────

final _wrapUpDataProvider =
    FutureProvider.family<_WrapUpData?, String>((ref, chatId) async {
  final result = await Supabase.instance.client
      .from('reflections')
      .select('id, what_sage_heard, question_to_sit_with, shared_perspective, arc_id, arcs(name)')
      .eq('chat_id', chatId)
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();

  if (result == null) return null;

  final arcsMap = result['arcs'] as Map<String, dynamic>?;
  return _WrapUpData(
    whatSageHeard: result['what_sage_heard'] as String? ?? '',
    questionToSitWith: result['question_to_sit_with'] as String? ?? '',
    sharedPerspective: result['shared_perspective'] as String? ?? '',
    arcId: result['arc_id'] as String?,
    arcName: arcsMap?['name'] as String?,
  );
});

class _WrapUpData {
  final String whatSageHeard;
  final String questionToSitWith;
  final String sharedPerspective;
  final String? arcId;
  final String? arcName;

  const _WrapUpData({
    required this.whatSageHeard,
    required this.questionToSitWith,
    required this.sharedPerspective,
    this.arcId,
    this.arcName,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────

class WrapUpScreen extends ConsumerWidget {
  final String chatId;

  const WrapUpScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_wrapUpDataProvider(chatId));

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      body: SafeArea(
        child: async.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white54),
          ),
          error: (_, __) => _Body(data: null, chatId: chatId),
          data: (data) => _Body(data: data, chatId: chatId),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final _WrapUpData? data;
  final String chatId;

  const _Body({required this.data, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SESSION WRAP-UP',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white38,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Where you\n',
                      style: GoogleFonts.dmSans(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    TextSpan(
                      text: 'traveled.',
                      style: GoogleFonts.dmSans(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA970FF).withOpacity(.65),
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              if (data?.arcName != null) ...[
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: data?.arcId != null
                      ? () => context.push('${AppRoutes.arcDetail}/${data!.arcId}')
                      : null,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF6EECD4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Sage thinks this lives near ',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                      Text(
                        data!.arcName!,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: Colors.white.withOpacity(.4),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 32),

        // ── Reflection cards ─────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: data == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'Reflection is still being processed.\nCheck back in a moment.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          color: Colors.white38,
                          height: 1.6,
                        ),
                      ),
                    ),
                  )
                : _buildCards(data!),
          ),
        ),

        // ── Actions ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: BorderSide(color: Colors.white.withOpacity(.2)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Home',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              if (data?.arcId != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.push('${AppRoutes.arcDetail}/${data!.arcId}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA970FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'View Arc',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCards(_WrapUpData d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (d.whatSageHeard.isNotEmpty)
          _Card(
            label: 'WHAT SAGE HEARD',
            content: d.whatSageHeard,
            bg: Colors.white.withOpacity(.06),
            border: Colors.white.withOpacity(.1),
          ),
        if (d.questionToSitWith.isNotEmpty) ...[
          const SizedBox(height: 14),
          _Card(
            label: 'QUESTION TO SIT WITH',
            content: d.questionToSitWith,
            bg: const Color(0xFFA970FF).withOpacity(.08),
            border: const Color(0xFFA970FF).withOpacity(.25),
            bold: true,
          ),
        ],
        if (d.sharedPerspective.isNotEmpty) ...[
          const SizedBox(height: 14),
          _Card(
            label: 'SHARED PERSPECTIVE',
            content: d.sharedPerspective,
            bg: const Color(0xFF6EECD4).withOpacity(.05),
            border: const Color(0xFF6EECD4).withOpacity(.18),
            contentColor: Colors.white.withOpacity(.75),
            italic: true,
          ),
        ],
      ],
    );
  }
}

// ── Shared card widget ────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final String label;
  final String content;
  final Color bg;
  final Color border;
  final Color contentColor;
  final bool bold;
  final bool italic;

  const _Card({
    required this.label,
    required this.content,
    required this.bg,
    required this.border,
    this.contentColor = Colors.white,
    this.bold = false,
    this.italic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white38,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              color: contentColor,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}
