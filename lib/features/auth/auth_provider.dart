import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final String? emailError;
  final bool emailSent;

  const AuthState({
    this.isLoading = false,
    this.emailError,
    this.emailSent = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? emailError,
    bool clearEmailError = false,
    bool? emailSent,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      emailSent: emailSent ?? this.emailSent,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  bool _isValidEmail(String email) =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(email);

  Future<void> sendMagicLink(String email) async {
    if (!_isValidEmail(email.trim())) {
      state = state.copyWith(emailError: 'Check that format');
      return;
    }
    state = state.copyWith(isLoading: true, clearEmailError: true);
    try {
      // TODO: Supabase magic link — await supabase.auth.signInWithOtp(email: email)
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false, emailSent: true);
    } catch (_) {
      state = state.copyWith(isLoading: false, emailError: 'Something went wrong');
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearEmailError: true);
    try {
      // TODO: Supabase Google OAuth — await supabase.auth.signInWithOAuth(OAuthProvider.google)
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, emailError: 'Google sign-in failed');
    }
  }

  void clearError() => state = state.copyWith(clearEmailError: true);
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
