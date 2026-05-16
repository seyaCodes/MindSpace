import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/arc_model.dart';

const _bg = Color(0xFF0A0E1A);
const _card = Color(0xFF141830);
const _elevated = Color(0xFF1A1F45);
const _border = Color(0xFF2A2D4A);
const _accent = Color(0xFF5C58ED);
const _cyan = Color(0xFF3FA9F5);
const _textSec = Color(0xFFB0B4C8);
const _textMuted = Color(0xFF6B6F8A);

class ArcDetailScreen extends StatelessWidget {
  final ArcModel arc;
  const ArcDetailScreen({super.key, required this.arc});

  @override
  Widget build(BuildContext context) {
    final isUnder3 = arc.sessionCount < 3;
    return isUnder3 ? _Under3View(arc: arc) : _FullView(arc: arc);
  }
}

// ── Under 3 sessions ──────────────────────────────────────────────────────────
class _Under3View extends StatelessWidget {
  final ArcModel arc;
  const _Under3View({required this.arc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Purple glow at top
          Positioned(
            top: -30,
            left: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF5C58ED).withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 160,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                ),
                title: Text('< Arcs',
                    style: GoogleFonts.inter(
                        color: _textSec, fontSize: 14, fontWeight: FontWeight.w400)),
                centerTitle: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1A1260), _bg],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(arc.title,
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Apr 22 – Apr 24 · ${arc.sessionCount} sessions',
                          style: GoogleFonts.inter(color: _textMuted, fontSize: 13)),
                      const SizedBox(height: 20),

                      // Locked card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [_card, _elevated],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _border, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF18172A),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _border, width: 0.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.auto_awesome, color: _textMuted, size: 12),
                                  const SizedBox(width: 6),
                                  Text('Locked until 3 sessions',
                                      style: GoogleFonts.inter(color: _textSec, fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Sage needs a little more to notice a pattern.',
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3),
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                    color: _textSec, fontSize: 14, height: 1.55),
                                children: [
                                  const TextSpan(text: 'You have '),
                                  TextSpan(
                                    text: '${arc.sessionCount} of 3 sessions',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        height: 1.55),
                                  ),
                                  const TextSpan(
                                      text: ' in this Arc. One more conversation and Sage can offer a macro insight.'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: List.generate(3, (i) {
                                final filled = i < arc.sessionCount;
                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                                    height: 4,
                                    decoration: BoxDecoration(
                                      gradient: filled
                                          ? const LinearGradient(colors: [_accent, _cyan])
                                          : null,
                                      color: filled ? null : _border,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      _SessionRow(
                        dotColor: const Color(0xFF10B981),
                        dateTime: 'Apr 24 · 8:00 PM',
                        summary: 'Small wins in holding space after a hard phone call.',
                      ),
                      const SizedBox(height: 10),
                      _SessionRow(
                        dotColor: const Color(0xFF6C72FF),
                        dateTime: 'Apr 22 · 7:00 PM',
                        summary: 'Why does saying no still feel like betrayal?',
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _border, width: 0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: _textMuted, size: 18),
                              const SizedBox(width: 8),
                              Text('Add past chat',
                                  style: GoogleFonts.inter(color: _textMuted, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Full (3+ sessions) view ────────────────────────────────────────────────────
class _FullView extends StatelessWidget {
  final ArcModel arc;
  const _FullView({required this.arc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Positioned(
            top: -30,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF5C58ED).withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3FA9F5).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back nav
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chevron_left, color: _textSec, size: 20),
                        Text('Arcs',
                            style: GoogleFonts.inter(color: _textSec, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                // Title block
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(arc.title,
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          const Icon(Icons.edit_outlined, color: _textMuted, size: 16),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Apr 15 – Apr 25 · ${arc.sessionCount} sessions',
                          style: GoogleFonts.inter(color: _textMuted, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      // Generate Arc Analysis CTA
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF1E1B5E), Color(0xFF112444)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _accent.withOpacity(0.3), width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [_accent, _cyan]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Generate Arc Analysis',
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                  Text('${arc.sessionCount} sessions ready for Arc Analysis',
                                      style: GoogleFonts.inter(color: _textMuted, fontSize: 11)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward, color: _textSec, size: 18),
                            const SizedBox(width: 14),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Emotional Journey chart
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [_card, _elevated],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _border, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('EMOTIONAL JOURNEY',
                                style: GoogleFonts.inter(
                                    color: _textMuted,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0)),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 80,
                              child: CustomPaint(
                                painter: _EmotionSnakePainter(),
                                size: const Size(double.infinity, 80),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: ['Apr 15', 'Apr 17', 'Apr 20', 'Apr 22', 'Apr 25']
                                  .map((d) => Text(d,
                                      style: GoogleFonts.inter(
                                          color: _textMuted, fontSize: 9)))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Session rows
                      _SessionRow(
                        dotColor: const Color(0xFF6C72FF),
                        dateTime: 'Apr 25 · 7:30 PM',
                        summary: 'Fear of being seen as not enough — the real...',
                      ),
                      const SizedBox(height: 10),
                      _SessionRow(
                        dotColor: const Color(0xFF6C72FF),
                        dateTime: 'Apr 22 · 10:30 PM',
                        summary: 'The waiting game is louder than the interview...',
                      ),
                      const SizedBox(height: 10),
                      _SessionRow(
                        dotColor: const Color(0xFFF39C12),
                        dateTime: 'Apr 20 · 6:00 PM',
                        summary: 'Comparing progress to peers. Noticed how s...',
                      ),
                      const SizedBox(height: 10),
                      _SessionRow(
                        dotColor: const Color(0xFF6C72FF),
                        dateTime: 'Apr 17 · 9:30 PM',
                        summary: 'Interview prep anxiety — realized I was prep...',
                      ),
                      const SizedBox(height: 10),
                      _SessionRow(
                        dotColor: const Color(0xFF10B981),
                        dateTime: 'Apr 15 · 8:00 PM',
                        summary: 'First session in this Arc. Named the pressure',
                      ),
                      const SizedBox(height: 12),

                      // Add past chat
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _border, width: 0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: _textMuted, size: 18),
                              const SizedBox(width: 8),
                              Text('Add past chat',
                                  style: GoogleFonts.inter(color: _textMuted, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  final Color dotColor;
  final String dateTime;
  final String summary;
  const _SessionRow({required this.dotColor, required this.dateTime, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_card, _elevated],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateTime,
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(summary,
                    style: GoogleFonts.inter(
                        color: _textSec, fontSize: 13, height: 1.4),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0F1428),
              border: Border.all(color: _border, width: 0.5),
            ),
            child: const Icon(Icons.arrow_back, color: _textMuted, size: 13),
          ),
        ],
      ),
    );
  }
}

// Snake/wave emotion chart painter
class _EmotionSnakePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 5 data points mapping to Y positions (0=top, 1=bottom)
    // Emotions: anxious(mid), anxious(mid), frustrated(peak), anxious(mid-low), anxious(mid)
    final yNorm = [0.4, 0.5, 0.75, 0.35, 0.4];
    final colors = [
      const Color(0xFF6C72FF),
      const Color(0xFF6C72FF),
      const Color(0xFFF39C12),
      const Color(0xFF6C72FF),
      const Color(0xFF6C72FF),
    ];

    final points = <Offset>[];
    for (int i = 0; i < 5; i++) {
      final x = (i / 4) * size.width;
      final y = yNorm[i] * size.height;
      points.add(Offset(x, y));
    }

    // Draw gradient line path
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final cp1 = Offset(
        points[i].dx + (points[i + 1].dx - points[i].dx) / 3,
        points[i].dy,
      );
      final cp2 = Offset(
        points[i].dx + 2 * (points[i + 1].dx - points[i].dx) / 3,
        points[i + 1].dy,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i + 1].dx, points[i + 1].dy);
    }

    // Line paint
    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF6C72FF), Color(0xFFF39C12), Color(0xFF6C72FF)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Draw dots
    for (int i = 0; i < points.length; i++) {
      final dotPaint = Paint()..color = colors[i];
      final outerPaint = Paint()
        ..color = _bg
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points[i], 7, outerPaint);
      canvas.drawCircle(points[i], 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}