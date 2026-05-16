import 'package:go_router/go_router.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/home/main_shell.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/session/free_space_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: '/free_space',
      builder: (context, state) => const FreeSpaceScreen(),
    ),
  ],
);
