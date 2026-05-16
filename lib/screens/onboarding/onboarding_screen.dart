import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

const _bg = Color(0xFF0A0E1A);
const _card = Color(0xFF141830);
const _border = Color(0xFF2A2D4A);
const _accent = Color(0xFF5C58ED);
const _teal = Color(0xFF3FA9F5);
const _textSec = Color(0xFFB0B4C8);
const _textMuted = Color.fromARGB(255, 11, 204, 159);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 2) {
      _ctrl.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut);
    } else {
      context.go('/home');
    }
  }

  void _skip() => context.go('/home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Purple glow top-center
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _accent.withOpacity(0.18),
                      _accent.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Teal glow bottom-right
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _teal.withOpacity(0.12),
                    _teal.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 24, 0),
                    child: GestureDetector(
                      onTap: _skip,
                      child: Text('Skip',
                          style:
                              GoogleFonts.inter(color: _textMuted, fontSize: 15)),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _ctrl,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => setState(() => _page = i),
                    children: const [_Slide1(), _Slide2(), _Slide3()],
                  ),
                ),
                _BottomBar(page: _page, onNext: _next),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int page;
  final VoidCallback onNext;
  const _BottomBar({required this.page, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final active = i == page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 72,
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: active
                      ? const LinearGradient(colors: [_accent, _teal])
                      : null,
                  color: active ? null : _border,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onNext,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_accent, _teal],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              alignment: Alignment.center,
              child: Text(
                page < 2 ? 'Continue →' : 'Get started →',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Slide 1 ───────────────────────────────────────────────────────────────────
class _Slide1 extends StatelessWidget {
  const _Slide1();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          SizedBox(
            width: 280,
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Large purple orb
                Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFF9D97FF),
                        Color(0xFF7B78FF),
                        Color(0xFF5C58ED),
                      ],
                      stops: [0.0, 0.55, 1.0],
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                        begin: const Offset(0.96, 0.96),
                        end: const Offset(1.04, 1.04),
                        duration: 2000.ms,
                        curve: Curves.easeInOut),
                // Small teal orb top-right
                Positioned(
                  top: 24,
                  right: 18,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF7ECFFF),
                          _teal,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _teal.withOpacity(0.35),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                          begin: const Offset(0.93, 0.93),
                          end: const Offset(1.07, 1.07),
                          duration: 1800.ms,
                          curve: Curves.easeInOut),
                ),
                // Small blue orb bottom-right
                Positioned(
                  bottom: 28,
                  right: 14,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Color(0xFF8CB3FF), Color(0xFF5B8DEF)],
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                          begin: const Offset(0.92, 0.92),
                          end: const Offset(1.08, 1.08),
                          duration: 2300.ms,
                          curve: Curves.easeInOut),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'A quiet place for\n',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: "what's loud.",
                      style: GoogleFonts.inter(
                        color: _teal,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Mind Space is a calm chat with Sage — an AI that listens before it solves. No streaks, no scores. Just a space to think out loud.',
                style: GoogleFonts.inter(
                    color: _textSec, fontSize: 15, height: 1.6),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ── Slide 2 ───────────────────────────────────────────────────────────────────
class _Slide2 extends StatelessWidget {
  const _Slide2();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          SizedBox(
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform(
                  transform: Matrix4.identity()
                    ..rotateZ(-0.18)
                    ..translate(-50.0, 10.0),
                  alignment: Alignment.center,
                  child: const _ArcCardPreview(title: 'Family', opacity: 0.45),
                ),
                Transform(
                  transform: Matrix4.identity()
                    ..rotateZ(-0.06)
                    ..translate(-16.0, 0.0),
                  alignment: Alignment.center,
                  child: const _ArcCardPreview(title: 'Moving', opacity: 0.72),
                ),
                Transform(
                  transform: Matrix4.identity()
                    ..rotateZ(0.08)
                    ..translate(28.0, -12.0),
                  alignment: Alignment.center,
                  child: const _ArcCardPreview(title: 'Job Hunt', opacity: 1.0),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Stories,\nnot ',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: 'streaks.',
                      style: GoogleFonts.inter(
                        color: _teal,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Conversations cluster into Arcs — chapters that show how a feeling actually moved. Sage surfaces patterns you couldn't see from inside.",
                style: GoogleFonts.inter(
                    color: _textSec, fontSize: 15, height: 1.6),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _ArcCardPreview extends StatelessWidget {
  final String title;
  final double opacity;
  const _ArcCardPreview({required this.title, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border, width: 0.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.folder_outlined, color: _teal, size: 22),
            const Spacer(),
            Text(title,
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: _accent)),
                const SizedBox(width: 4),
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFEF4444))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Slide 3 ───────────────────────────────────────────────────────────────────
class _Slide3 extends StatelessWidget {
  const _Slide3();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF141830).withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _accent.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [_accent, _teal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.shield_outlined,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Private to your account',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Export anytime. Delete in one tap.',
                          style: GoogleFonts.inter(
                              color: _textSec, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Yours,\nnever ',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: 'shared.',
                      style: GoogleFonts.inter(
                        color: _teal,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Sage isn't a therapist — and won't pretend to be. Your sessions stay private to your account, you can export them as JSON, and you can wipe everything in one tap. Anytime.",
                style: GoogleFonts.inter(
                    color: _textSec, fontSize: 15, height: 1.6),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
