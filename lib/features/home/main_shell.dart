import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/history/history_screen.dart';
import '../../screens/insights/insights_screen.dart';
import '../../screens/settings/settings_screen.dart';

final shellIndexProvider = NotifierProvider<ShellIndex, int>(ShellIndex.new);

class ShellIndex extends Notifier<int> {
  @override
  int build() => 0;
  void set(int i) => state = i;
}

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(shellIndexProvider);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0D1F),
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: idx == 2 ? 0 : idx,
            children: const [
              HomeScreen(),
              HistoryScreen(),
              SizedBox(),
              InsightsScreen(),
              SettingsScreen(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _FloatingNav(
              current: idx,
              bottomInset: bottomInset,
              onTap: (i) {
                if (i == 2) {
                  context.go('/free_space');
                } else {
                  ref.read(shellIndexProvider.notifier).set(i);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingNav extends StatelessWidget {
  final int current;
  final double bottomInset;
  final ValueChanged<int> onTap;

  const _FloatingNav({
    required this.current,
    required this.bottomInset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomInset),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0F20).withOpacity(0.92),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.09),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            active: current == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.menu_book_outlined,
            active: current == 1,
            onTap: () => onTap(1),
          ),
          _FabItem(onTap: () => onTap(2)),
          _NavItem(
            icon: Icons.show_chart,
            active: current == 3,
            onTap: () => onTap(3),
          ),
          _NavItem(
            icon: Icons.settings_outlined,
            active: current == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: active ? const Color(0xFF4DD9C0) : const Color(0xFF4A4F6A),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: active ? 4 : 0,
              height: active ? 4 : 0,
              decoration: const BoxDecoration(
                color: Color(0xFF4DD9C0),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabItem extends StatelessWidget {
  final VoidCallback onTap;

  const _FabItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF5C58ED),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }
}
