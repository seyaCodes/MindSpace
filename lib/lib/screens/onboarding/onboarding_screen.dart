import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final Set<int> _selectedTopics = {};
  bool _remindMe = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _next() {
    if (_currentPage < 2) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut);
    } else {
      _goHome();
    }
  }

  void _back() {
    _controller.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut);
  }

  void _toggleTopic(int i) {
    setState(() {
      if (_selectedTopics.contains(i)) {
        _selectedTopics.remove(i);
      } else {
        _selectedTopics.add(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E1A),
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 24, 0),
                child: GestureDetector(
                  onTap: _goHome,
                  child: Text('Skip',
                      style: GoogleFonts.inter(
                          color: Colors.white38,
                          fontSize: 15)),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                ],
              ),
            ),

            // Bottom dots + buttons
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 40, 28, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            'Not a therapist.\nNot a journal. A\nconversation that\nhelps you\nunderstand\nyourself.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'Sage asks questions. You answer\nhonestly. That\'s it.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white54,
              fontSize: 17,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    const topics = [
      'Work pressure',
      'Relationships',
      'Self-doubt',
      'Just need to think out loud',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'What usually brings\nyou here?',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select any that apply',
            style: GoogleFonts.inter(
                color: Colors.white38, fontSize: 16),
          ),
          const SizedBox(height: 36),
          ...List.generate(topics.length, (i) {
            final active = _selectedTopics.contains(i);
            return GestureDetector(
              onTap: () => _toggleTopic(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 20),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF8B5CF6).withOpacity(0.18)
                      : const Color(0xFF1A1A2A),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: active
                        ? const Color(0xFF8B5CF6)
                        : Colors.white.withOpacity(0.1),
                    width: active ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  topics[i],
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Let\'s personalize\nyour space',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'What should Sage call you?',
            style: GoogleFonts.inter(
                color: Colors.white54, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2A),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              controller: _nameController,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
              decoration: InputDecoration(
                hintText: 'First name',
                hintStyle: GoogleFonts.inter(
                    color: Colors.white38, fontSize: 17),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 18),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 22, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Remind me to check in',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Daily notification',
                        style: GoogleFonts.inter(
                            color: Colors.white38, fontSize: 13)),
                  ],
                ),
                Switch(
                  value: _remindMe,
                  onChanged: (v) => setState(() => _remindMe = v),
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF8B5CF6),
                  inactiveThumbColor: Colors.white70,
                  inactiveTrackColor: Colors.white24,
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _goHome,
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.5),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'Start my first session',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dots
          Row(
            children: List.generate(3, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: active ? 28 : 10,
                height: 10,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF8B5CF6) : Colors.white24,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            }),
          ),
          // Back + Next
          Row(
            children: [
              if (_currentPage > 0) ...[
                GestureDetector(
                  onTap: _back,
                  child: Container(
                    width: 52, height: 52,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white12,
                    ),
                    child: const Icon(Icons.chevron_left,
                        color: Colors.white, size: 26),
                  ),
                ),
              ],
              if (_currentPage < 2)
                GestureDetector(
                  onTap: _next,
                  child: Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF8B5CF6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withOpacity(0.55),
                          blurRadius: 20, spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.chevron_right,
                        color: Colors.white, size: 26),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
