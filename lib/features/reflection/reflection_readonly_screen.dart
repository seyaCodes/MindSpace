import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

// ═══════════════════════════════════════════════════════════
// REFLECTION READ-ONLY SCREEN (S8)
// Shown when user taps a session card from Arc Detail or Timeline
// ═══════════════════════════════════════════════════════════

class _MockReflection {
  final String id;
  final String arcName;
  final Color arcColor;
  final String date;
  final String spiritName;
  final Color spiritColor;
  final String whatSageHeard;
  final String questionToSitWith;
  final String? momentOfClarity;
  final String sharedPerspective;
  final int sessionNumber;
  final int totalSessions;

  const _MockReflection({
    required this.id,
    required this.arcName,
    required this.arcColor,
    required this.date,
    required this.spiritName,
    required this.spiritColor,
    required this.whatSageHeard,
    required this.questionToSitWith,
    this.momentOfClarity,
    required this.sharedPerspective,
    required this.sessionNumber,
    required this.totalSessions,
  });
}

final _mockReflection = _MockReflection(
  id: '1',
  arcName: 'The Job Hunt',
  arcColor: const Color(0xFF6C5CE7),
  date: 'APR 25, 2026 · 7:30 PM',
  spiritName: 'Anxious',
  spiritColor: const Color(0xFF6C5CE7),
  whatSageHeard:
      'Underneath the stress of preparing for tomorrow, I heard a fear of being seen as not enough — not the role itself, but the version of you that has to show up for it.',
  questionToSitWith:
      'What would it feel like if your worth wasn\'t on the line tomorrow?',
  momentOfClarity:
      'You named the spiral before it pulled you under tonight. That\'s a different kind of moment.',
  sharedPerspective:
      'Many people carrying the weight of a job search find that the surface stress is rarely the real one. The thing being tested isn\'t the skill — it\'s whether you\'re allowed to take up space.',
  sessionNumber: 3,
  totalSessions: 5,
);

class ReflectionReadonlyScreen extends StatelessWidget {
  final String reflectionId;

  const ReflectionReadonlyScreen({super.key, required this.reflectionId});

  @override
  Widget build(BuildContext context) {
    final r = _mockReflection; // replace with provider later

    return Scaffold(
      backgroundColor: Colors.transparent,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Row(
                    children: [
                      const Icon(Icons.chevron_left,
                          color: Color(0xFF9B9BA0), size: 22),
                      const SizedBox(width: 2),
                      Text(
                        'Back',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF9B9BA0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Header: arc pill + date
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: r.arcColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: r.arcColor.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: r.arcColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          r.arcName.toUpperCase(),
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: r.arcColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    r.date,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      color: const Color(0xFF5A5A60),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Spirit orb
                Center(
                  child: _SpiritOrb(color: r.spiritColor, size: 110),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    r.spiritName,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: r.spiritColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // What Sage Heard
                _ReflectionSection(
                  label: 'What Sage heard',
                  body: r.whatSageHeard,
                  accentColor: r.spiritColor,
                ),
                const SizedBox(height: 28),

                // Question to sit with
                _ReflectionSection(
                  label: 'A question to sit with',
                  body: r.questionToSitWith,
                  accentColor: const Color(0xFFA8E063),
                  italic: true,
                ),
                const SizedBox(height: 28),

                // Moment of clarity (if present)
                if (r.momentOfClarity != null) ...[
                  _ReflectionSection(
                    label: 'A moment of clarity',
                    body: r.momentOfClarity!,
                    accentColor: const Color(0xFF00C48C),
                  ),
                  const SizedBox(height: 28),
                ],

                // Shared perspective
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF5B8DEF).withOpacity(0.25),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A shared perspective',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF5B8DEF),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        r.sharedPerspective,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: const Color(0xFFD0D0D8),
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Arc footer
                Center(
                  child: Text(
                    'Session ${r.sessionNumber} of ${r.totalSessions} · ${r.arcName}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: const Color(0xFF5A5A60),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReflectionSection extends StatelessWidget {
  final String label;
  final String body;
  final Color accentColor;
  final bool italic;

  const _ReflectionSection({
    required this.label,
    required this.body,
    required this.accentColor,
    this.italic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: accentColor,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFF5F5F7),
            height: 1.6,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }
}

class _SpiritOrb extends StatefulWidget {
  final Color color;
  final double size;

  const _SpiritOrb({required this.color, required this.size});

  @override
  State<_SpiritOrb> createState() => _SpiritOrbState();
}

class _SpiritOrbState extends State<_SpiritOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.color,
                  widget.color.withOpacity(0.7),
                  widget.color.withOpacity(0.2),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}