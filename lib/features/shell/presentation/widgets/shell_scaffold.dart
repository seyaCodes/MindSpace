import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import 'bottom_nav_bar.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ShellScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: MindSpaceBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
        onCenterTap: () => context.push(AppRoutes.chat),
      ),
    );
  }
}