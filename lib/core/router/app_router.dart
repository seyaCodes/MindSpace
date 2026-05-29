import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/profile_repository.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile_setup/profile_setup_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/widgets/shell_scaffold.dart';
import '../../features/splash/splash_screen.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const profileSetup = '/profile-setup';

  static const home = '/home';
  static const history = '/history';
  static const settings = '/settings';
}

final appRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) =>
              const SplashScreen(),
        ),

        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) =>
              const OnboardingScreen(),
        ),

        GoRoute(
          path: AppRoutes.auth,
          builder: (context, state) =>
              const AuthScreen(),
        ),

        GoRoute(
          path: AppRoutes.profileSetup,
          builder: (context, state) =>
              const ProfileSetupScreen(),
        ),

        ShellRoute(
          builder: (context, state, child) {
            final location =
                state.uri.toString();

            int index = 0;

            if (location ==
                AppRoutes.history) {
              index = 1;
            } else if (location ==
                AppRoutes.settings) {
              index = 2;
            }

            return ShellScaffold(
              currentIndex: index,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go(AppRoutes.home);
                    break;

                  case 1:
                    context.go(
                        AppRoutes.history);
                    break;

                  case 2:
                    context.go(
                        AppRoutes.settings);
                    break;
                }
              },
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) =>
                  const HomeScreen(),
            ),

            GoRoute(
              path: AppRoutes.history,
              builder: (context, state) =>
                  const HistoryScreen(),
            ),

            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) =>
                  const SettingsScreen(),
            ),
          ],
        ),
      ],

      redirect: (context, state) async {
        final location =
            state.uri.toString();

        // Splash handles its own navigation
        if (location == AppRoutes.splash) {
          return null;
        }

        final prefs =
            await SharedPreferences
                .getInstance();

        final onboardingSeen =
            prefs.getBool('onboarding_seen') ??
                false;

        final session = Supabase
            .instance.client.auth.currentSession;

        final isAuth =
            location == AppRoutes.auth;

        final isOnboarding =
            location == AppRoutes.onboarding;

        // Must complete onboarding first
        if (!onboardingSeen && !isOnboarding) {
          return AppRoutes.onboarding;
        }

        // No session — must authenticate
        if (session == null &&
            !isAuth &&
            !isOnboarding) {
          return AppRoutes.auth;
        }

        // Has session — enforce profile completion on every route
        if (session != null) {
          final profile = await ProfileRepository(
            Supabase.instance.client,
          ).fetchProfile(session.user.id);
          final hasName =
              profile?.displayName?.trim().isNotEmpty == true;
          final isProfileSetup =
              location == AppRoutes.profileSetup;

          if (!hasName && !isProfileSetup) {
            return AppRoutes.profileSetup;
          }
          if (hasName && isProfileSetup) {
            return AppRoutes.home;
          }
        }

        return null;
      },
    );
  },
);