import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'history_provider.dart';
import 'timeline_tab.dart';
import 'arcs_tab.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const HistoryScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(historyProvider.notifier).setTab(widget.initialTab);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3D2B7A),
              Color(0xFF1A1F5E),
              Color(0xFF0E1340),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: Row(
                        children: [
                          const Icon(Icons.chevron_left,
                              color: Color(0xFF9B9BA0), size: 22),
                          const SizedBox(width: 2),
                          Text(
                            'Mind Space',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: const Color(0xFF9B9BA0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'History',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF5F5F7),
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.selectedTab == 0
                          ? 'Your memory vault'
                          : 'Your story chapters',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: const Color(0xFF9B9BA0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SegmentedToggle(
                  selectedIndex: state.selectedTab,
                  onChanged: (i) =>
                      ref.read(historyProvider.notifier).setTab(i),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: state.selectedTab == 0
                    ? const TimelineTab()
                    : const ArcsTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _SegmentedToggle({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              icon: Icons.access_time,
              label: 'Timeline',
              isActive: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _Segment(
              icon: Icons.folder_outlined,
              label: 'Arcs',
              isActive: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _Segment({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFFA89BF5), Color(0xFF7DD3D8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF1A1040)
                  : const Color(0xFF9B9BA0),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? const Color(0xFF1A1040)
                    : const Color(0xFFF5F5F7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}