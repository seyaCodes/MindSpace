import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FreeSpaceScreen extends StatefulWidget {
  final String arcTitle;
  final String prompt;

  const FreeSpaceScreen({
    super.key,
    this.arcTitle = 'FREE SPACE',
    this.prompt = "What's sitting with you\nright now?",
  });

  @override
  State<FreeSpaceScreen> createState() => _FreeSpaceScreenState();
}

class _FreeSpaceScreenState extends State<FreeSpaceScreen> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.chevron_left, color: Colors.white60, size: 28),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.folder_outlined, color: Colors.white54, size: 13),
                        const SizedBox(width: 6),
                        Text(widget.arcTitle.toUpperCase(),
                            style: GoogleFonts.inter(
                                color: Colors.white54,
                                fontSize: 11,
                                letterSpacing: 1.2)),
                      ],
                    ),
                  ),
                  const Icon(Icons.bookmark_border, color: Colors.white54, size: 22),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Text(
                    widget.prompt,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF111120),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Start typing...',
                          hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF8B5CF6).withOpacity(0.2),
                      ),
                      child: const Icon(Icons.arrow_forward, color: Color(0xFF8B5CF6), size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
