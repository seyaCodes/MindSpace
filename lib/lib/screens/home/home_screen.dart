import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../session/free_space_screen.dart';
import '../history/history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _goTo(BuildContext context, String title, String prompt) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => FreeSpaceScreen(arcTitle: title, prompt: prompt),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080810),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                children: [
                  Text('APRIL 22, 2026',
                      style: GoogleFonts.inter(color: Colors.white38, fontSize: 12, letterSpacing: 1.6, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Evening, Seya.',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w300, letterSpacing: -1.0)),
                  const SizedBox(height: 4),
                  Text('Sage is listening.',
                      style: GoogleFonts.inter(color: Colors.white38, fontSize: 16)),
                  const SizedBox(height: 44),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Open Threads', style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500)),
                      // View all → goes to History Arcs tab
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => const HistoryScreenStandalone(),
                        )),
                        child: Text('View all', style: GoogleFonts.inter(color: Colors.white38, fontSize: 15)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () => _goTo(context, 'The Job Hunt',
                        'Last time, we realized your anxiety is tied to waiting, not interviewing. How are you holding up with the waiting game today?'),
                    child: _ThreadCard(
                      arcTitle: 'The Job Hunt',
                      lastMessage: '"Last time, we realized your anxiety is tied to waiting, not interviewing."',
                      dotColors: const [Color(0xFF8B5CF6), Color(0xFFEF4444), Color(0xFF10B981)],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _goTo(context, 'Family Boundaries',
                        'You mentioned feeling drained after the call. Ready to unpack that?'),
                    child: _ThreadCard(
                      arcTitle: 'Family Boundaries',
                      lastMessage: '"You mentioned feeling drained after the call. Ready to unpack that?"',
                      dotColors: const [Color(0xFF3B82F6), Color(0xFF10B981), Color(0xFFFBBF24)],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _goTo(context, 'New Theme', "Let's explore this new space. What's on your mind?"),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.create_new_folder_outlined, color: Colors.white38, size: 20),
                          const SizedBox(width: 10),
                          Text('Start a new theme', style: GoogleFonts.inter(color: Colors.white54, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _goTo(context, 'Free Space', "What's sitting with you\nright now?"),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Container(
                  height: 66,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF18182A),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF8B5CF6).withOpacity(0.15)),
                        child: const Icon(Icons.mic, color: Color(0xFF8B5CF6), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text("What's on your mind?",
                            style: GoogleFonts.inter(color: Colors.white38, fontSize: 15)),
                      ),
                      Container(
                        width: 46, height: 46,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8B5CF6)),
                        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Standalone history screen that opens directly on Arcs tab
class HistoryScreenStandalone extends StatefulWidget {
  const HistoryScreenStandalone({super.key});
  @override
  State<HistoryScreenStandalone> createState() => _HistoryScreenStandaloneState();
}

class _HistoryScreenStandaloneState extends State<HistoryScreenStandalone> {
  @override
  Widget build(BuildContext context) {
    return const HistoryScreen(startOnArcs: true);
  }
}

class _ThreadCard extends StatelessWidget {
  final String arcTitle;
  final String lastMessage;
  final List<Color> dotColors;
  const _ThreadCard({required this.arcTitle, required this.lastMessage, required this.dotColors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.09)),
            child: const Icon(Icons.folder_outlined, color: Colors.white54, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(arcTitle, style: GoogleFonts.inter(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(lastMessage, style: GoogleFonts.inter(color: Colors.white54, fontSize: 14, height: 1.55)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: dotColors.map((c) => Container(
                        width: 12, height: 12,
                        margin: const EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: c),
                      )).toList(),
                    ),
                    Text('Continue →', style: GoogleFonts.inter(color: const Color(0xFF8B5CF6), fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
