import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';
import '../../data/mock_data.dart';
import '../../models/session_model.dart';
import '../../widgets/arc_card.dart';
import '../session/reflection_screen.dart';
import 'arc_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  final bool startOnArcs;
  const HistoryScreen({super.key, this.startOnArcs = false});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late bool _showArcs = widget.startOnArcs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080810),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
              child: Text('History', style: GoogleFonts.inter(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 42,
                decoration: BoxDecoration(color: const Color(0xFF12122A), borderRadius: BorderRadius.circular(22)),
                child: Row(children: [
                  _Tab(label: 'Timeline', active: !_showArcs, onTap: () => setState(() => _showArcs = false)),
                  _Tab(label: 'Arcs',     active: _showArcs,  onTap: () => setState(() => _showArcs = true)),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _showArcs ? const _ArcsView() : const _TimelineView()),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label; final bool active; final VoidCallback onTap;
  const _Tab({required this.label, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(color: active ? const Color(0xFF1E1E3A) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        child: Text(label, style: GoogleFonts.inter(color: active ? Colors.white : Colors.white38, fontSize: 14, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
      ),
    ),
  );
}

class _TimelineView extends StatelessWidget {
  const _TimelineView();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, kNavBarTotalHeight),
      children: [
        _MonthHeader(label: 'THIS MONTH (APRIL)', dotColors: const [Color(0xFF8B5CF6), Color(0xFF10B981), Color(0xFFEF4444), Color(0xFFFBBF24), Color(0xFF3B82F6)]),
        const SizedBox(height: 14),
        _DayHeader(label: 'TODAY, APRIL 22', color: const Color(0xFF8B5CF6)),
        const SizedBox(height: 10),
        _SessionTile(session: mockSessions[0]),
        const SizedBox(height: 10),
        _SessionTile(session: mockSessions[1]),
        const SizedBox(height: 18),
        _DayHeader(label: 'MONDAY, APRIL 19', color: const Color(0xFF10B981)),
        const SizedBox(height: 10),
        _SessionTile(session: mockSessions[2]),
        const SizedBox(height: 24),
        _MonthHeader(label: 'PAST MONTH (MARCH)', dotColors: const [Color(0xFF8B5CF6), Color(0xFFFBBF24), Color(0xFF10B981)]),
        const SizedBox(height: 14),
        _DayHeader(label: 'SUNDAY, MARCH 28', color: const Color(0xFFFBBF24)),
        const SizedBox(height: 10),
        _SessionTile(session: mockSessions[3]),
      ],
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final String label; final List<Color> dotColors;
  const _MonthHeader({required this.label, required this.dotColors});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.calendar_today_outlined, color: Colors.white38, size: 13),
    const SizedBox(width: 8),
    Text(label, style: GoogleFonts.inter(color: Colors.white38, fontSize: 11, letterSpacing: 1.2)),
    const Spacer(),
    ...dotColors.map((c) => Container(width: 9, height: 9, margin: const EdgeInsets.only(left: 5), decoration: BoxDecoration(shape: BoxShape.circle, color: c))),
  ]);
}

class _DayHeader extends StatelessWidget {
  final String label; final Color color;
  const _DayHeader({required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 9, height: 9, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
    const SizedBox(width: 10),
    Text(label, style: GoogleFonts.inter(color: Colors.white54, fontSize: 11, letterSpacing: 1.1, fontWeight: FontWeight.w600)),
  ]);
}

class _SessionTile extends StatelessWidget {
  final SessionModel session;
  const _SessionTile({required this.session});

  Color _moodColor() {
    switch (session.mood) {
      case SessionMood.calm:       return const Color(0xFF10B981);
      case SessionMood.reflective: return const Color(0xFF8B5CF6);
      case SessionMood.tense:      return const Color(0xFFFBBF24);
      case SessionMood.neutral:    return const Color(0xFF10B981);
    }
  }

  String _timeLabel() {
    final h = session.dateTime.hour;
    final m = session.dateTime.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$h12:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF12122A), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.07))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 11, height: 11, decoration: BoxDecoration(shape: BoxShape.circle, color: _moodColor())),
          const SizedBox(width: 8),
          Text(_timeLabel(), style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          if (session.tag != null) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white10),
              child: Row(children: [
                const Icon(Icons.folder_outlined, color: Colors.white38, size: 11),
                const SizedBox(width: 4),
                Text(session.tag!, style: GoogleFonts.inter(color: Colors.white54, fontSize: 10, letterSpacing: 0.8)),
              ]),
            ),
          ],
        ]),
        const SizedBox(height: 10),
        Text(session.summary, style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, height: 1.5)),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${session.durationMin} min', style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReflectionScreen())),
            child: Row(children: [
              Text('View Reflection', style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
              const Icon(Icons.chevron_right, color: Colors.white38, size: 16),
            ]),
          ),
        ]),
      ]),
    );
  }
}

class _ArcsView extends StatelessWidget {
  const _ArcsView();
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.fromLTRB(24, 0, 24, kNavBarTotalHeight),
      crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 1,
      children: mockArcs.map((arc) => GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArcDetailScreen(arc: arc))),
        child: ArcCard(arc: arc),
      )).toList(),
    );
  }
}
