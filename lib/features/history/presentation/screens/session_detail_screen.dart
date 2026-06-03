import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/providers/reflection_providers.dart';
import '../../../../data/repositories/reflection_repository.dart';

class SessionDetailScreen extends ConsumerWidget {
  final String sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(reflectionProvider(sessionId));

    return Scaffold(
      backgroundColor: const Color(0xFF171F5A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text(
            'Could not load session.',
            style: TextStyle(color: Colors.white54),
          ),
        ),
        data: (session) => session == null
            ? const Center(
                child: Text(
                  'Session not found.',
                  style: TextStyle(color: Colors.white54),
                ),
              )
            : _SessionDetailBody(session: session),
      ),
    );
  }
}

String _asSecondPerson(String text) => text
    .replaceAll("The user's", 'Your')
    .replaceAll("the user's", 'your')
    .replaceAll('The user', 'You')
    .replaceAll('the user', 'you');

class _SessionDetailBody extends StatelessWidget {
  final ReflectionModel session;

  const _SessionDetailBody({required this.session});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(session.createdAt),
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: Colors.white38,
              letterSpacing: 1.2,
            ),
          ),
          if (session.questionToSitWith.isNotEmpty) ...[
            const SizedBox(height: 28),
            _SectionLabel('QUESTION TO SIT WITH'),
            const SizedBox(height: 8),
            Text(
              session.questionToSitWith,
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ],
          if (session.whatSageHeard.isNotEmpty) ...[
            const SizedBox(height: 28),
            _SectionLabel('WHAT SAGE HEARD'),
            const SizedBox(height: 8),
            Text(
              _asSecondPerson(session.whatSageHeard),
              style: GoogleFonts.dmSans(
                fontSize: 15,
                color: Colors.white70,
                height: 1.65,
              ),
            ),
          ],
          if ((session.sharedPerspective ?? '').isNotEmpty) ...[
            const SizedBox(height: 28),
            _SectionLabel('SHARED PERSPECTIVE'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFA970FF).withOpacity(.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFA970FF).withOpacity(.2),
                ),
              ),
              child: Text(
                _asSecondPerson(session.sharedPerspective!),
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: Colors.white70,
                  height: 1.65,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.white38,
        letterSpacing: 1.4,
      ),
    );
  }
}
