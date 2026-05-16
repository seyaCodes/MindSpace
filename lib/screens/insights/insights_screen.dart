import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';

const _bg = Color(0xFF0A0E1A);
const _card = Color(0xFF141830);
const _teal = Color(0xFF3FA9F5);
const _textMuted = Color(0xFF6B6F8A);

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Purple glow top-left
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF5C58ED).withOpacity(0.35),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          // Teal glow bottom-right
          Positioned(
            bottom: 60,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF3FA9F5).withOpacity(0.2),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, kNavBarTotalHeight),
              children: [
                const SizedBox(height: 28),

                // Title
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Weekly\n',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1)),
                            TextSpan(
                                text: 'Pulse.',
                                style: GoogleFonts.inter(
                                    color: _teal,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    height: 1.1)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: _teal.withOpacity(0.3), width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: _teal),
                          ),
                          const SizedBox(width: 6),
                          Text('PULSE',
                              style: GoogleFonts.inter(
                                  color: _teal,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Apr 19 – Apr 25 · across all Arcs',
                    style: GoogleFonts.inter(color: _textMuted, fontSize: 14)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: _teal),
                    ),
                    const SizedBox(width: 8),
                    Text('THIRD ANALYSIS TYPE · CROSS-ARC · WEEKLY',
                        style: GoogleFonts.inter(
                            color: _teal,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8)),
                  ],
                ),
                const SizedBox(height: 24),

                // ── YOUR WEEK, AT A GLANCE ────────────────────────────
                _PulseCard(
                  label: 'YOUR WEEK, AT A GLANCE',
                  labelColor: _textMuted,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 110,
                        child: CustomPaint(
                          size: const Size(double.infinity, 110),
                          painter: _WeekWavePainter(),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _DayLabel('Sat'),
                          _DayLabel('Sun'),
                          _DayLabel('Mon'),
                          _DayLabel('Tue'),
                          _DayLabel('Wed'),
                          _DayLabel('Thu'),
                          _DayLabel('Fri'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ── THE THREAD THIS WEEK ──────────────────────────────
                _PulseCard(
                  labelIcon: Icons.auto_awesome,
                  label: 'THE THREAD THIS WEEK',
                  labelColor: _teal,
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                          color: Colors.white, fontSize: 15, height: 1.6),
                      children: const [
                        TextSpan(text: 'Across '),
                        TextSpan(
                            text: '3 Arcs',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: ' and '),
                        TextSpan(
                            text: '6 sessions',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                ', the same shape kept showing up: you anticipate judgment, then meet it with quiet preparation. The fear and the readiness are travelling together.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ── WHERE YOU SPENT TIME ──────────────────────────────
                _PulseCard(
                  label: 'WHERE YOU SPENT TIME',
                  labelColor: _textMuted,
                  child: Column(
                    children: const [
                      _ArcTimeRow(
                        name: 'The Job Hunt',
                        sessions: 3,
                        color: Color(0xFF8B5CF6),
                        fraction: 0.60,
                      ),
                      SizedBox(height: 14),
                      _ArcTimeRow(
                        name: 'Family Boundaries',
                        sessions: 2,
                        color: Color(0xFF3FA9F5),
                        fraction: 0.40,
                      ),
                      SizedBox(height: 14),
                      _ArcTimeRow(
                        name: 'Moving Out',
                        sessions: 1,
                        color: Color(0xFF10B981),
                        fraction: 0.20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ── A QUESTION FOR THE WEEK AHEAD ─────────────────────
                _PulseCard(
                  labelIcon: Icons.help_outline,
                  label: 'A QUESTION FOR THE WEEK AHEAD',
                  labelColor: const Color(0xFFF59E0B),
                  accentColor: const Color(0xFFF59E0B),
                  child: Text(
                    'What does it cost you to keep preparing for judgment that might not come?',
                    style: GoogleFonts.inter(
                        color: Colors.white, fontSize: 15, height: 1.55),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Text('Something feels off ›',
                      style: GoogleFonts.inter(
                          color: _textMuted, fontSize: 13)),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cards ─────────────────────────────────────────────────────────────────────
class _PulseCard extends StatelessWidget {
  final String label;
  final IconData? labelIcon;
  final Color labelColor;
  final Color? accentColor;
  final Widget child;

  const _PulseCard({
    required this.label,
    required this.labelColor,
    required this.child,
    this.labelIcon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? Colors.white;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Color.lerp(_card, accent, 0.04)!.withOpacity(0.82),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent.withOpacity(0.12), width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (labelIcon != null) ...[
                    Icon(labelIcon, color: labelColor, size: 13),
                    const SizedBox(width: 6),
                  ],
                  Text(label,
                      style: GoogleFonts.inter(
                          color: labelColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8)),
                ],
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _ArcTimeRow extends StatelessWidget {
  final String name;
  final int sessions;
  final Color color;
  final double fraction;

  const _ArcTimeRow({
    required this.name,
    required this.sessions,
    required this.color,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.folder_outlined, color: color, size: 15),
            const SizedBox(width: 8),
            Expanded(
              child: Text(name,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ),
            Text('$sessions session${sessions == 1 ? '' : 's'}',
                style: GoogleFonts.inter(color: _textMuted, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (_, constraints) => Stack(
            children: [
              Container(
                  height: 4,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                      color: const Color(0xFF1E2240),
                      borderRadius: BorderRadius.circular(2))),
              Container(
                  height: 4,
                  width: constraints.maxWidth * fraction,
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2))),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String day;
  const _DayLabel(this.day);

  @override
  Widget build(BuildContext context) {
    return Text(day,
        style: GoogleFonts.inter(color: _textMuted, fontSize: 10));
  }
}

// ── Wave chart painter ────────────────────────────────────────────────────────
class _WeekWavePainter extends CustomPainter {
  static const _values = [0.55, 0.30, 0.50, 0.52, 0.45, 0.62, 0.78];
  static const _colors = [
    Color(0xFF8B5CF6),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
    Color(0xFF8B5CF6),
    Color(0xFF3FA9F5),
    Color(0xFF3FA9F5),
    Color(0xFF10B981),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final n = _values.length;
    final pts = List.generate(n, (i) {
      final x = size.width * i / (n - 1);
      final y = size.height * 0.15 + size.height * 0.70 * (1 - _values[i]);
      return Offset(x, y);
    });

    // Draw line with gradient stroke
    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF3FA9F5), Color(0xFF10B981)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < n; i++) {
      final cp1 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
      final cp2 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // Draw dots
    for (int i = 0; i < n; i++) {
      canvas.drawCircle(pts[i], 7,
          Paint()..color = _colors[i]);
      canvas.drawCircle(pts[i], 3.5,
          Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
