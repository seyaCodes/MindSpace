import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import 'bottom_nav.dart';

final shellIndexProvider = StateProvider<int>((ref) => 0);

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static const _routes = ['/', '/history', '/analysis', '/settings'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(shellIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      extendBody: true,
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: idx,
        onTap: (i) {
          ref.read(shellIndexProvider.notifier).state = i;
          context.go(_routes[i]);
        },
        onFabTap: () => context.push('/chat'),
      ),
    );
  }
}
