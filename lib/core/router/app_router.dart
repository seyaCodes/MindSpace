import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/analysis/presentation/screens/analysis_screen.dart';
import '../../data/repositories/profile_repository.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/wrap_up_screen.dart';
import '../../features/history/presentation/screens/arc_analysis_screen.dart';
import '../../features/history/presentation/screens/arc_detail_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/history/presentation/screens/session_detail_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile_setup/profile_setup_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/widgets/shell_scaffold.dart';
import '../../features/splash/splash_screen.dart';

// Navigator keys — ensures routes outside ShellRoute always use the root
// navigator, even when pushed from within the shell's inner navigator.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Notifies GoRouter whenever Supabase auth state changes so redirect re-runs
// automatically — fixes the case where OAuth login completes but the router
// stays on /auth because the deep-link crash prevented the original navigation.
class _AuthChangeNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _sub;

  _AuthChangeNotifier() {
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const profileSetup = '/profile-setup';
  static const chat = '/chat';
  static const wrapUp = '/wrap-up';
  static const arcDetail = '/arc';
  static const sessionDetail = '/session';

  static const home = '/home';
  static const history = '/history';
  static const analysis = '/analysis';
  static const settings = '/settings';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthChangeNotifier();
  ref.onDispose(notifier.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      // These routes must use parentNavigatorKey so they always push onto the
      // root navigator when called via context.push() from inside ShellRoute.
      GoRoute(
        path: '/chat',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/wrap-up/:chatId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => WrapUpScreen(
          chatId: state.pathParameters['chatId']!,
        ),
      ),
      GoRoute(
        path: '/arc/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ArcDetailScreen(
          arcId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/arc/:id/analysis',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ArcAnalysisScreen(
          arcId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/session/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => SessionDetailScreen(
          sessionId: state.pathParameters['id']!,
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          final location = state.uri.toString();

          int index = 0;
          if (location.startsWith(AppRoutes.history)) index = 1;
          else if (location.startsWith(AppRoutes.analysis)) index = 2;
          else if (location.startsWith(AppRoutes.settings)) index = 3;

          return ShellScaffold(
            currentIndex: index,
            onTap: (i) {
              switch (i) {
                case 0: context.go(AppRoutes.home);
                case 1: context.go(AppRoutes.history);
                case 2: context.go(AppRoutes.analysis);
                case 3: context.go(AppRoutes.settings);
              }
            },
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.history,
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.analysis,
            builder: (context, state) => const AnalysisScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      final uri = state.uri;

      // Skip routing for Supabase OAuth callback URIs (io.supabase.mindspace://…).
      // GoRouter crashes calling uri.origin on non-http schemes; supabase_flutter
      // handles these independently via its own deep-link listener.
      if (uri.scheme != 'http' &&
          uri.scheme != 'https' &&
          uri.scheme.isNotEmpty) {
        return null;
      }

      final location = uri.toString();
      if (location == AppRoutes.splash) return null;

      final prefs = await SharedPreferences.getInstance();
      final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
      final session = Supabase.instance.client.auth.currentSession;

      final isAuth = location == AppRoutes.auth;
      final isOnboarding = location == AppRoutes.onboarding;

      if (!onboardingSeen && !isOnboarding) return AppRoutes.onboarding;
      if (session == null && !isAuth && !isOnboarding) return AppRoutes.auth;

      if (session != null) {
        final profile = await ProfileRepository(
          Supabase.instance.client,
        ).fetchProfile(session.user.id);
        final hasName = profile?.displayName?.trim().isNotEmpty == true;
        final isProfileSetup = location == AppRoutes.profileSetup;

        if (isAuth || isOnboarding) {
          return hasName ? AppRoutes.home : AppRoutes.profileSetup;
        }
        if (!hasName && !isProfileSetup) return AppRoutes.profileSetup;
        if (hasName && isProfileSetup) return AppRoutes.home;
      }

      return null;
    },
  );
});
