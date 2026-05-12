import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/insights/insights_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/session/free_space_screen.dart';

const double kNavBarTotalHeight = 110.0;

class MindSpaceApp extends StatelessWidget {
  const MindSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindSpace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080810),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFFA78BFA),
          surface: Color(0xFF12122A),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login':       (_) => const LoginScreen(),
        '/onboarding':  (_) => const OnboardingScreen(),
        '/home':        (_) => const MainShell(),
        '/free_space':  (_) => const FreeSpaceScreen(),
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;

  final _pages = const [
    HomeScreen(),
    HistoryScreen(),
    SizedBox(),
    InsightsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080810),
      extendBody: true,
      body: IndexedStack(index: _idx == 2 ? 0 : _idx, children: _pages),
      bottomNavigationBar: _BottomNav(
        current: _idx,
        onTap: (i) {
          if (i == 2) {
            Navigator.pushNamed(context, '/free_space');
          } else {
            setState(() => _idx = i);
          }
        },
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C2A),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(0.10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavIcon(icon: Icons.home_outlined,      active: current == 0, onTap: () => onTap(0)),
            _NavIcon(icon: Icons.menu_book_outlined,  active: current == 1, onTap: () => onTap(1)),
            GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8B5CF6),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withOpacity(0.6),
                      blurRadius: 24, spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
            _NavIcon(icon: Icons.show_chart,         active: current == 3, onTap: () => onTap(3)),
            _NavIcon(icon: Icons.settings_outlined,  active: current == 4, onTap: () => onTap(4)),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _NavIcon({required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, size: 26,
            color: active ? Colors.white : Colors.white38),
      ),
    );
  }
}
