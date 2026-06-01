import 'package:flutter/material.dart';

class MindSpaceBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;

  const MindSpaceBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: 110 + bottomPadding,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: bottomPadding,
            left: 16,
            right: 16,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF090B2A),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.white.withOpacity(.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.35),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    active: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    icon: Icons.menu_book_rounded,
                    active: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  const SizedBox(width: 58),
                  _NavItem(
                    icon: Icons.trending_up_rounded,
                    active: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _NavItem(
                    icon: Icons.settings_rounded,
                    active: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: onCenterTap,
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFC89BFF),
                      Color(0xFFA970FF),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFA970FF).withOpacity(.45),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
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

  const _NavItem({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          size: 24,
          color: active ? Colors.white : Colors.white.withOpacity(.55),
        ),
      ),
    );
  }
}
