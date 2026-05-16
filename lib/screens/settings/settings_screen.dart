import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF0A0E1A);
const _card = Color(0xFF141830);
const _border = Color(0xFF2A2D4A);
const _accent = Color(0xFF6C72FF);
const _cyan = Color(0xFF4DD9C0);
const _textSec = Color(0xFFB0B4C8);
const _textMuted = Color(0xFF6B6F8A);
const _red = Color(0xFFE74C3C);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _patternQuestions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Your account & your data',
                      style:
                          GoogleFonts.inter(color: _textSec, fontSize: 15)),
                ],
              ),
            ),

            // Account card
            _Padded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border, width: 0.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [_accent, Color(0xFF4B4FBF)],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text('S',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Seya Maral',
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('seya.maral@gmail.com',
                              style: GoogleFonts.inter(
                                  color: _textMuted, fontSize: 13)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1E18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF1A4035), width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF4DD9C0)),
                          ),
                          const SizedBox(width: 5),
                          Text('Synced',
                              style: GoogleFonts.inter(
                                  color: _cyan,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _SectionLabel('SAGE'),
            _Padded(
              child: Container(
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border, width: 0.5),
                ),
                child: Column(
                  children: [
                    _SettingsRow(
                      icon: Icons.access_time_outlined,
                      label: 'Wrap-Up reminder',
                      trailing: Text('Off',
                          style: GoogleFonts.inter(
                              color: _textMuted, fontSize: 14)),
                    ),
                    _Divider(),
                    _SettingsRow(
                      icon: Icons.auto_awesome_outlined,
                      label: 'Tone of voice',
                      trailing: Text('Calm, curious',
                          style: GoogleFonts.inter(
                              color: _textMuted, fontSize: 14)),
                    ),
                    _Divider(),
                    _SettingsRow(
                      icon: Icons.lightbulb_outline,
                      label: 'Pattern questions',
                      trailing: Switch(
                        value: _patternQuestions,
                        onChanged: (v) =>
                            setState(() => _patternQuestions = v),
                        activeTrackColor: _accent,
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.white54,
                        inactiveTrackColor: _border,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _SectionLabel('PRIVACY & DATA'),
            _Padded(
              child: Container(
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border, width: 0.5),
                ),
                child: Column(
                  children: [
                    _SettingsRow(
                      icon: Icons.lock_outline,
                      label: 'Passcode lock',
                      trailing: Text('On',
                          style: GoogleFonts.inter(
                              color: _textMuted, fontSize: 14)),
                    ),
                    _Divider(),
                    _SettingsRow(
                      icon: Icons.download_outlined,
                      label: 'Export all data',
                      trailing: Text('JSON',
                          style: GoogleFonts.inter(
                              color: _textMuted, fontSize: 14)),
                    ),
                    _Divider(),
                    _SettingsRow(
                      icon: Icons.delete_outline,
                      label: 'Delete account',
                      labelColor: _red,
                      iconColor: _red,
                      trailing: const Icon(Icons.chevron_right,
                          color: _red, size: 20),
                    ),
                  ],
                ),
              ),
            ),

            _SectionLabel('ABOUT'),
            _Padded(
              child: Container(
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border, width: 0.5),
                ),
                child: Column(
                  children: [
                    _SettingsRow(
                      icon: Icons.access_time_outlined,
                      label: 'Crisis resources',
                      trailing: const Icon(Icons.chevron_right,
                          color: _textMuted, size: 20),
                    ),
                    _Divider(),
                    _SettingsRow(
                      icon: Icons.chat_bubble_outline,
                      label: 'Send feedback',
                      trailing: const Icon(Icons.chevron_right,
                          color: _textMuted, size: 20),
                    ),
                    _Divider(),
                    _SettingsRow(
                      icon: Icons.check_circle_outline,
                      label: 'Version',
                      trailing: Text('1.0.0 · build 0512',
                          style: GoogleFonts.inter(
                              color: _textMuted, fontSize: 13)),
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

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
      child: Text(text,
          style: GoogleFonts.inter(
              color: _textMuted,
              fontSize: 11,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _Padded extends StatelessWidget {
  final Widget child;
  const _Padded({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
        height: 1, thickness: 0.5, color: _border, indent: 16, endIndent: 16);
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? labelColor;
  final Color? iconColor;
  final Widget trailing;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.labelColor,
    this.iconColor,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2240),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon,
                color: iconColor ?? _textSec, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: GoogleFonts.inter(
                  color: labelColor ?? Colors.white,
                  fontSize: 15,
                )),
          ),
          trailing,
        ],
      ),
    );
  }
}
