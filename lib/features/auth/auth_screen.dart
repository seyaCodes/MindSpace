import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_controller.dart' show AuthController, AuthFormState, authControllerProvider;
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/profile_repository.dart';
import 'package:mind_space/shared/widgets/app_background.dart';
import 'package:mind_space/shared/widgets/cta_button.dart';
import 'auth_controller.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _focusNode = FocusNode();
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    _listenAuthState();
  }

  void _listenAuthState() {
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      if (!mounted) return;
      if (data.event != AuthChangeEvent.signedIn) return;

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        context.go(AppRoutes.home);
        return;
      }

      final profile = await ref
          .read(profileRepositoryProvider)
          .fetchProfile(userId);

      if (!mounted) return;
      final hasName = profile?.displayName?.trim().isNotEmpty == true;
      context.go(hasName ? AppRoutes.home : AppRoutes.profileSetup);
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            const AppBarLogo(),
            Expanded(
              child: GestureDetector(
                onTap: () => _focusNode.unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Headline(),
                      const SizedBox(height: 8),
                      _Subtitle(),
                      const SizedBox(height: 36),
                      _EmailField(
                        controller: _emailController,
                        focusNode: _focusNode,
                      ),
                      const SizedBox(height: 12),
                      CtaButton(
                        label: 'Send magic link →',
                        loading: state.isMagicLinkLoading,
                        onTap: () => _sendMagicLink(state),
                      ),
                      const SizedBox(height: 28),
                      const _OrDivider(),
                      const SizedBox(height: 28),
                      _GoogleButton(
                        loading: state.isGoogleLoading,
                        onTap: () => ref
                            .read(authControllerProvider.notifier)
                            .signInWithGoogle(),
                      ),
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        _ErrorBanner(message: state.errorMessage!),
                      ],
                      if (state.magicLinkSent) ...[
                        const SizedBox(height: 16),
                        _SuccessBanner(email: _emailController.text.trim()),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const _LegalFooter(),
          ],
        ),
      ),
    );
  }

  void _sendMagicLink(AuthFormState state) {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    _focusNode.unfocus();
    ref.read(authControllerProvider.notifier).sendMagicLink(email);
  }
}

class _Headline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Welcome ',
            style: GoogleFonts.dmSans(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          TextSpan(
            text: 'in.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 40,
              fontStyle: FontStyle.italic,
              color: AppColors.accentPurple,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'No passwords — your inbox does the work. Sign in and pick up where you left off.',
      style: GoogleFonts.dmSans(
        fontSize: 15,
        color: AppColors.textMuted,
        height: 1.55,
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _EmailField({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.mail_outline_rounded,
              color: AppColors.textSubtle, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              style: GoogleFonts.dmSans(
                fontSize: 15,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'you@example.com',
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: AppColors.textSubtle,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.white.withOpacity(0.12), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSubtle,
              letterSpacing: 1.4,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.white.withOpacity(0.12), thickness: 1),
        ),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _GoogleButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: loading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white54),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoogleGlyph(),
                  const SizedBox(width: 12),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Real Google glyph — painted manually, no asset needed
class _GoogleGlyph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GoogleGlyphPainter()),
    );
  }
}

class _GoogleGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Blue arc (top-right)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -1.38, 2.76, false,
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    // Red arc (top-left)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -3.84, 1.57, false,
      Paint()
        ..color = const Color(0xFFEA4335)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    // Yellow arc (bottom-left)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      2.36, 1.18, false,
      Paint()
        ..color = const Color(0xFFFBBC05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    // Green arc (bottom-right)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      1.26, 1.05, false,
      Paint()
        ..color = const Color(0xFF34A853)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    // Horizontal bar (right side)
    canvas.drawLine(
      Offset(cx, cy),
      Offset(size.width, cy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = size.width * 0.18,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Text(
        message,
        style: GoogleFonts.dmSans(fontSize: 13, color: Colors.redAccent),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  final String email;
  const _SuccessBanner({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accentTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentTeal.withOpacity(0.3)),
      ),
      child: Text(
        'Magic link sent to $email. Check your inbox.',
        style: GoogleFonts.dmSans(
          fontSize: 13,
          color: AppColors.accentTeal,
        ),
      ),
    );
  }
}

class _LegalFooter extends StatelessWidget {
  const _LegalFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: AppColors.textSubtle,
            height: 1.6,
          ),
          children: [
            const TextSpan(text: 'By continuing you agree to our '),
            TextSpan(
              text: 'Terms',
              style: const TextStyle(color: AppColors.accentTeal),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy',
              style: const TextStyle(color: AppColors.accentTeal),
            ),
            const TextSpan(
              text: '.\nSage is a reflection tool, not a substitute for professional care.',
            ),
          ],
        ),
      ),
    );
  }
}

