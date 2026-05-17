import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_provider.dart';
import '../../app/router.dart';

const _bg = Color(0xFF0A0E1A);
const _card = Color(0xFF141830);
const _border = Color(0xFF2A2D4A);
const _accent = Color(0xFF6C72FF);
const _cyan = Color(0xFF4DD9C0);
const _textSec = Color(0xFFB0B4C8);
const _textMuted = Color(0xFF6B6F8A);

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSendMagicLink() async {
    await ref
        .read(authNotifierProvider.notifier)
        .sendMagicLink(_emailCtrl.text);
    if (!mounted) return;
    final s = ref.read(authNotifierProvider);
    if (s.emailSent) context.go('/onboarding');
  }

  Future<void> _onGoogleSignIn() async {
  await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  if (!mounted) return;
  final s = ref.read(authNotifierProvider);
  if (!s.isLoading && s.emailError == null) {
    ref.read(authStateProvider.notifier).state = true;
    context.go('/');
  }
}

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [Color(0xFF1A1635), _bg],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Brand mark
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0xFF9D97FF), _accent],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Mind Space',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 52),

                Text(
                  'Welcome',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                  ),
                ),
                Text(
                  'back.',
                  style: GoogleFonts.inter(
                    color: _cyan,
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    height: 1.05,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Sign in to pick up where you left off. No passwords — your inbox does the work.',
                  style: GoogleFonts.inter(
                    color: _textSec,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 36),

                // Email field
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: auth.emailError != null
                          ? const Color(0xFFE74C3C)
                          : _border,
                      width: auth.emailError != null ? 1.0 : 0.5,
                    ),
                  ),
                  child: TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) {
                      if (auth.emailError != null) {
                        ref
                            .read(authNotifierProvider.notifier)
                            .clearError();
                      }
                    },
                    style: GoogleFonts.inter(
                        color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'you@example.com',
                      hintStyle: GoogleFonts.inter(
                          color: _textMuted, fontSize: 15),
                      prefixIcon: Icon(Icons.mail_outline,
                          color: _textMuted, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                  ),
                ),

                if (auth.emailError != null) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(auth.emailError!,
                        style: GoogleFonts.inter(
                            color: const Color(0xFFE74C3C),
                            fontSize: 12)),
                  ),
                ],

                const SizedBox(height: 14),

                // Send magic link button
                GestureDetector(
                  onTap: auth.isLoading ? null : _onSendMagicLink,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_accent, _cyan],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    alignment: Alignment.center,
                    child: auth.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Send magic link',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  )),
                              const SizedBox(width: 8),
                              const Text('→',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // OR divider
                Row(
                  children: [
                    const Expanded(
                        child: Divider(color: _border, thickness: 0.5)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR',
                          style: GoogleFonts.inter(
                              color: _textMuted,
                              fontSize: 12,
                              letterSpacing: 1.2)),
                    ),
                    const Expanded(
                        child: Divider(color: _border, thickness: 0.5)),
                  ],
                ),

                const SizedBox(height: 24),

                // Continue with Google
                GestureDetector(
                  onTap: _onGoogleSignIn,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: _border, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          alignment: Alignment.center,
                          child: Text('G',
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 10),
                        Text('Continue with Google',
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 56),

                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                          color: _textMuted, fontSize: 11, height: 1.6),
                      children: [
                        const TextSpan(text: 'By continuing you agree to our '),
                        TextSpan(
                          text: 'Terms',
                          style: GoogleFonts.inter(
                              color: _cyan, fontSize: 11),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy',
                          style: GoogleFonts.inter(
                              color: _cyan, fontSize: 11),
                        ),
                        const TextSpan(
                          text:
                              '.\nSage is a reflection tool, not a substitute for professional care.',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
