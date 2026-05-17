import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mind_space/features/onboarding/onboarding_screen.dart';
import 'package:mind_space/features/auth/auth_screen.dart';
import 'package:mind_space/features/home/home_screen.dart';
import 'package:mind_space/features/history/history_screen.dart';
import 'package:mind_space/features/analysis/analysis_screen.dart';
import 'package:mind_space/features/settings/settings_screen.dart';
import 'package:mind_space/features/chat/chat_screen.dart';
import 'package:mind_space/features/arc_detail/arc_detail_screen.dart';
import 'package:mind_space/features/arc_detail/arc_analysis_screen.dart';
import 'package:mind_space/features/reflection/reflection_readonly_screen.dart';
import 'package:mind_space/shell/app_shell.dart';

// ═══════════════════════════════════════════════════════════
// AUTH STATE PROVIDER (replace with Supabase Auth later)
// ═══════════════════════════════════════════════════════════
final authStateProvider = StateProvider<bool>((ref) => false); // false = signed out
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

// ═══════════════════════════════════════════════════════════
// ROUTER
// ═══════════════════════════════════════════════════════════
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isSignedIn = ref.read(authStateProvider);
      final onboardingDone = ref.read(onboardingCompleteProvider);

      final loc = state.matchedLocation;
      final isAuthRoute = loc == '/auth' || loc == '/onboarding';

      // First-time users → onboarding
      if (!onboardingDone && loc != '/onboarding') {
        return '/onboarding';
      }

      // Onboarding done but not signed in → auth
      if (onboardingDone && !isSignedIn && !isAuthRoute) {
        return '/auth';
      }

      // Signed in but on an auth route → home
      if (isSignedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      // Onboarding (no shell)
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      // Auth (no shell)
      GoRoute(
        path: '/auth',
        builder: (_, __) => const AuthScreen(),
      ),

      // Main shell — 4 tabs
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) {
              final tab = state.uri.queryParameters['tab'];
              return HistoryScreen(initialTab: tab == 'arcs' ? 1 : 0);
            },
          ),
          GoRoute(
            path: '/analysis',
            builder: (_, __) => const AnalysisScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),

      // Chat — full-screen dialog (slides up, hides tab bar)
      GoRoute(
        path: '/chat',
        pageBuilder: (context, state) => MaterialPage(
          fullscreenDialog: true,
          child: ChatScreen(
            arcId: state.uri.queryParameters['arcId'],
          ),
        ),
      ),

      // Arc Detail — pushed (no shell, has back button)
      GoRoute(
        path: '/arc/:id',
        builder: (context, state) => ArcDetailScreen(
          arcId: state.pathParameters['id']!,
        ),
      ),

      // Arc Analysis — pushed on top of Arc Detail
      GoRoute(
        path: '/arc/:id/analysis',
        builder: (context, state) => ArcAnalysisScreen(
          arcId: state.pathParameters['id']!,
        ),
      ),

      // Reflection (read-only) — pushed
      GoRoute(
        path: '/reflection/:id',
        builder: (context, state) => ReflectionReadonlyScreen(
          reflectionId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});

// ═══════════════════════════════════════════════════════════
// Helper: bootstrap onboarding state from SharedPreferences
// Call this once in main.dart before runApp
// ═══════════════════════════════════════════════════════════
Future<void> initRouterState(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  ref.read(onboardingCompleteProvider.notifier).state =
      prefs.getBool('onboarding_complete') ?? false;
}
