import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthFormState {
  final bool isMagicLinkLoading;
  final bool isGoogleLoading;
  final bool magicLinkSent;
  final String? errorMessage;

  const AuthFormState({
    this.isMagicLinkLoading = false,
    this.isGoogleLoading = false,
    this.magicLinkSent = false,
    this.errorMessage,
  });

  AuthFormState copyWith({
    bool? isMagicLinkLoading,
    bool? isGoogleLoading,
    bool? magicLinkSent,
    String? errorMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AuthFormState(
      isMagicLinkLoading: isMagicLinkLoading ?? this.isMagicLinkLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      magicLinkSent: clearSuccess ? false : (magicLinkSent ?? this.magicLinkSent),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthController extends StateNotifier<AuthFormState> {
  final SupabaseClient _client;

  AuthController(this._client) : super(const AuthFormState());

  Future<void> sendMagicLink(String email) async {
    state = state.copyWith(
      isMagicLinkLoading: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      await _client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.supabase.mindspace://login-callback',
      );
      state = state.copyWith(
        isMagicLinkLoading: false,
        magicLinkSent: true,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        isMagicLinkLoading: false,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        isMagicLinkLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(
      isGoogleLoading: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.mindspace://login-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      // Auth state change listener in auth_screen handles navigation
      state = state.copyWith(isGoogleLoading: false);
    } on AuthException catch (e) {
      state = state.copyWith(
        isGoogleLoading: false,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        isGoogleLoading: false,
        errorMessage: 'Google sign-in failed. Please try again.',
      );
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthFormState>((ref) {
  return AuthController(Supabase.instance.client);
});

