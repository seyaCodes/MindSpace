import 'package:flutter/material.dart';
import '../app/theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onFabTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomInset),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // ── 5-slot bar ───────────────────────────────────────────────────────
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavSlot(icon: Icons.home_outlined,      index: 0, current: currentIndex, onTap: onTap),
                _NavSlot(icon: Icons.menu_book_outlined, index: 1, current: currentIndex, onTap: onTap),
                const SizedBox(width: 56), // reserved space for FAB
                _NavSlot(icon: Icons.show_chart_rounded, index: 2, current: currentIndex, onTap: onTap),
                _NavSlot(icon: Icons.settings_outlined,  index: 3, current: currentIndex, onTap: onTap),
              ],
            ),
          ),
          // ── FAB floats above bar ─────────────────────────────────────────────
          Positioned(
            top: -16,
            child: GestureDetector(
              onTap: onFabTap,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentPurple,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentPurple.withOpacity(0.45),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavSlot extends StatelessWidget {
  final IconData icon;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavSlot({
    required this.icon,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = current == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 23,
              color: active ? Colors.white : AppColors.textTertiary,
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: active ? 4 : 0,
              height: active ? 4 : 0,
              decoration: const BoxDecoration(
                color: AppColors.accentPurple,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
