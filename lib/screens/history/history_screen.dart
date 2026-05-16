import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'arc_detail_screen.dart';
import '../../data/mock_data.dart';
import '../../models/arc_model.dart';
import '../../models/session_model.dart';

const _bg = Color(0xFF0A0E1A);
const _card = Color(0xFF141830);
const _elevated = Color(0xFF1A1F45);
const _border = Color(0xFF2A2D4A);
const _accent = Color(0xFF5C58ED);
const _cyan = Color(0xFF3FA9F5);
const _textSec = Color(0xFFB0B4C8);
const _textMuted = Color(0xFF6B6F8A);

class HistoryScreen extends StatefulWidget {
  final bool startOnArcs;
  const HistoryScreen({super.key, this.startOnArcs = false});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late bool _showArcs;
  bool _archivedExpanded = false;

  @override
  void initState() {
    super.initState();
    _showArcs = widget.startOnArcs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Purple top-left blob
          Positioned(
            top: -40,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
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
          // Teal bottom-right blob
          Positioned(
            bottom: 80,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
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
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('History',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(
                        _showArcs ? 'Your story chapters' : 'Your memory vault',
                        style: GoogleFonts.inter(color: _textSec, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SegmentedControl(
                    showArcs: _showArcs,
                    onToggle: (v) => setState(() => _showArcs = v),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _showArcs
                      ? _ArcsView(
                          archivedExpanded: _archivedExpanded,
                          onToggleArchived: () => setState(
                              () => _archivedExpanded = !_archivedExpanded),
                        )
                      : const _TimelineView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  final bool showArcs;
  final ValueChanged<bool> onToggle;
  const _SegmentedControl({required this.showArcs, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1228),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: _border, width: 0.5),
      ),
      child: Row(
        children: [
          _Tab(
            icon: Icons.access_time_outlined,
            label: 'Timeline',
            active: !showArcs,
            onTap: () => onToggle(false),
          ),
          _Tab(
            icon: Icons.folder_outlined,
            label: 'Arcs',
            active: showArcs,
            onTap: () => onToggle(true),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: active ? _accent : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: active ? Colors.white : _textMuted),
              const SizedBox(width: 8),
              Text(label,
                  style: GoogleFonts.inter(
                      color: active ? Colors.white : _textMuted,
                      fontSize: 16,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Timeline ──────────────────────────────────────────────────────────────────
class _TimelineView extends StatefulWidget {
  const _TimelineView();

  @override
  State<_TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<_TimelineView> {
  int _filterIdx = 0;

  static const _filters = ['All', 'Anxious', 'Sad', 'Calm', 'Frustr.'];
  static const _filterMoods = [null, SessionMood.anxious, SessionMood.sad, SessionMood.calm, SessionMood.frustrated];
  static const _filterColors = [null, Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFF10B981), Color(0xFFF59E0B)];

  List<SessionModel> get _filtered {
    final mood = _filterMoods[_filterIdx];
    if (mood == null) return mockSessions;
    return mockSessions.where((s) => s.mood == mood).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (mockSessions.isEmpty) return const _TimelineEmpty();
    return CustomScrollView(
      slivers: [
        // Week strip
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const _WeekCalendarStrip(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _border, width: 0.5),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(Icons.search, color: _textMuted, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Search your reflections...',
                        style: GoogleFonts.inter(color: _textMuted, fontSize: 14)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _elevated,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.tune, color: _textSec, size: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        // Filter pills
        SliverToBoxAdapter(
          child: SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final active = _filterIdx == i;
                final dotColor = _filterColors[i];
                return GestureDetector(
                  onTap: () => setState(() => _filterIdx = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? _accent : _card,
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                          color: active ? Colors.transparent : _border, width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (dotColor != null) ...[
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: active ? Colors.white : dotColor,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                        Text(_filters[i],
                            style: GoogleFonts.inter(
                                color: active ? Colors.white : _textSec,
                                fontSize: 13,
                                fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // Date-grouped sessions
        SliverList(
          delegate: SliverChildListDelegate(
            _buildGroupedSessions(_filtered),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  List<Widget> _buildGroupedSessions(List<SessionModel> sessions) {
    final result = <Widget>[];
    String? lastLabel;
    for (final s in sessions) {
      final label = _dateLabel(s.dateTime);
      if (label != lastLabel) {
        final count = sessions.where((x) => _dateLabel(x.dateTime) == label).length;
        result.add(Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _moodColor(s.mood),
                ),
              ),
              Text(
                count > 1 ? '$label · $count SESSIONS' : label,
                style: GoogleFonts.inter(
                    color: _textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8),
              ),
            ],
          ),
        ));
        lastLabel = label;
      }
      result.add(Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
        child: _SessionCard(session: s),
      ));
    }
    return result;
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime(2026, 4, 25);
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == now) return 'TODAY, APRIL ${dt.day}';
    if (d == now.subtract(const Duration(days: 1))) return 'FRIDAY, APRIL ${dt.day}';
    const months = ['', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    const days = ['', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return '${days[dt.weekday]}, ${months[dt.month]} ${dt.day}';
  }
}

class _WeekCalendarStrip extends StatelessWidget {
  const _WeekCalendarStrip();

  static const _dayNames = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  static const _dates = [19, 20, 21, 22, 23, 24, 25];
  static const _dots = [null, Color(0xFF8B5CF6), null, Color(0xFF8B5CF6), null, Color(0xFF10B981), Color(0xFF8B5CF6)];
  static const _todayIdx = 6;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('APRIL 2026',
                  style: GoogleFonts.inter(
                      color: _textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8)),
              Text('Month view',
                  style: GoogleFonts.inter(color: _cyan, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final isToday = i == _todayIdx;
              final dot = _dots[i];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_dayNames[i],
                      style: GoogleFonts.inter(
                          color: _textMuted,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: isToday
                        ? BoxDecoration(
                            color: _accent,
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    alignment: Alignment.center,
                    child: Text('${_dates[i]}',
                        style: GoogleFonts.inter(
                            color: isToday ? Colors.white : Colors.white,
                            fontSize: 13,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400)),
                  ),
                  const SizedBox(height: 5),
                  if (dot != null)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: dot),
                    )
                  else
                    const SizedBox(height: 5),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final SessionModel session;
  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final timeStr = _timeStr(session.dateTime);
    final moodName = session.mood.name[0].toUpperCase() + session.mood.name.substring(1);
    final dotColor = _moodColor(session.mood);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141830).withOpacity(0.80),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(right: 7),
                decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
              ),
              Text(moodName,
                  style: GoogleFonts.inter(
                      color: dotColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              Text(' · $timeStr',
                  style: GoogleFonts.inter(color: _textMuted, fontSize: 13)),
              const Spacer(),
              if (session.tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1428),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _border, width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.folder_outlined, size: 10, color: _textMuted),
                      const SizedBox(width: 4),
                      Text(session.tag!,
                          style: GoogleFonts.inter(
                              color: _textMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3)),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _elevated,
                  border: Border.all(color: _border, width: 0.5),
                ),
                child: const Icon(Icons.arrow_back, color: _textMuted, size: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(session.summary,
              style: GoogleFonts.inter(
                  color: Colors.white, fontSize: 14, height: 1.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('${session.durationMin} min',
                  style: GoogleFonts.inter(color: _textMuted, fontSize: 12)),
              const Spacer(),
              Text('View Reflection ›',
                  style: GoogleFonts.inter(
                      color: _cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  String _timeStr(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
}

class _TimelineEmpty extends StatelessWidget {
  const _TimelineEmpty();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        Center(
          child: SizedBox(
            width: 180,
            height: 130,
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  top: 10,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF6C72FF).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF4DD9C0).withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Text('Your reflections will live here.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Text(
                'After your first chat, Sage saves a quiet reflection in this space.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    color: _textSec, fontSize: 14, height: 1.55),
              ),
            ],
          ),
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}

// ── Arcs ─────────────────────────────────────────────────────────────────────
class _ArcsView extends StatelessWidget {
  final bool archivedExpanded;
  final VoidCallback onToggleArchived;
  const _ArcsView({required this.archivedExpanded, required this.onToggleArchived});

  @override
  Widget build(BuildContext context) {
    final active = mockArcs.where((a) => !a.isArchived).toList();
    final archived = mockArcs.where((a) => a.isArchived).toList();

    if (active.isEmpty && archived.isEmpty) return const _ArcsEmpty();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      children: [
        // Section header
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ACTIVE THREADS',
                    style: GoogleFonts.inter(
                        color: _textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8)),
                Text('${active.length} ongoing arcs',
                    style: GoogleFonts.inter(color: _textSec, fontSize: 13)),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _border, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.grid_view, color: _textSec, size: 14),
                  const SizedBox(width: 5),
                  Text('Organize',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _accent,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Active grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
          children: active
              .map((arc) => GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ArcDetailScreen(arc: arc)),
                    ),
                    child: _ArcGridCard(arc: arc),
                  ))
              .toList(),
        ),

        if (archived.isNotEmpty) ...[
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onToggleArchived,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border, width: 0.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.archive_outlined, color: _textMuted, size: 16),
                  const SizedBox(width: 10),
                  Text('ARCHIVED CHAPTERS (${archived.length})',
                      style: GoogleFonts.inter(
                          color: _textSec,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6)),
                  const Spacer(),
                  Icon(
                    archivedExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: _textMuted,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (archivedExpanded) ...[
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
              children: archived
                  .map((arc) => _ArcGridCard(arc: arc, dimmed: true))
                  .toList(),
            ),
          ],
        ],
      ],
    );
  }
}

class _ArcGridCard extends StatelessWidget {
  final ArcModel arc;
  final bool dimmed;
  const _ArcGridCard({required this.arc, this.dimmed = false});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dimmed ? 0.55 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dimmed
              ? const Color(0xFF141830).withOpacity(0.55)
              : const Color(0xFF141830).withOpacity(0.80),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.folder_outlined,
                    color: dimmed ? _textMuted : _cyan, size: 20),
                const Spacer(),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _textMuted.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(arc.title,
                style: GoogleFonts.inter(
                    color: dimmed ? _textSec : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('${arc.sessionCount} sessions',
                style: GoogleFonts.inter(color: _textMuted, fontSize: 11)),
            const SizedBox(height: 10),
            Row(
              children: arc.dotColors
                  .take(5)
                  .map((c) => Container(
                        width: 9,
                        height: 9,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: c),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcsEmpty extends StatelessWidget {
  const _ArcsEmpty();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        Center(
          child: SizedBox(
            width: 200,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Transform(
                    transform: Matrix4.identity()
                      ..rotateZ([-0.15, -0.04, 0.1][i])
                      ..translate([-40.0, -12.0, 24.0][i], [8.0, 0.0, -8.0][i]),
                    alignment: Alignment.center,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFF2A2D4A).withOpacity(0.5), width: 0.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.folder_outlined,
                            color: Color(0xFF2A2D4A), size: 24),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Text('Arcs form when stories repeat.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Text(
                'After a few chats, Sage starts noticing themes — and chapters appear here on their own.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: _textSec, fontSize: 14, height: 1.55),
              ),
            ],
          ),
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}

// Helpers
Color _moodColor(SessionMood mood) {
  switch (mood) {
    case SessionMood.anxious:
      return const Color(0xFF8B5CF6);
    case SessionMood.calm:
      return const Color(0xFF10B981);
    case SessionMood.sad:
      return const Color(0xFF3B82F6);
    case SessionMood.frustrated:
      return const Color(0xFFF59E0B);
    case SessionMood.hopeful:
      return const Color(0xFFA8E063);
    case SessionMood.overwhelmed:
      return const Color(0xFFE17055);
  }
}