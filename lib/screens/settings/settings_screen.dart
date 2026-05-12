import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _notifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomCenter,
          colors: [Color(0xFF3B1278), Color(0xFF22085A), Color(0xFF110830), Color(0xFF090914)],
          stops: [0.0, 0.2, 0.45, 1.0],
        ))),
        Positioned(top: -60, left: -60, child: Container(
          width: 300, height: 300,
          decoration: BoxDecoration(shape: BoxShape.circle,
            gradient: RadialGradient(colors: [const Color(0xFF7C3AED).withOpacity(0.45), Colors.transparent])),
        )),
        SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(0, 0, 0, kNavBarTotalHeight),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                child: Text('Settings', style: GoogleFonts.inter(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              _SectionLabel('APPEARANCE'),
              _SettingsTile(leading: const Icon(Icons.dark_mode_outlined, color: Colors.white60, size: 20),
                title: 'Theme', subtitle: 'Dark mode',
                trailing: Switch(value: _darkMode, onChanged: (v) => setState(() => _darkMode = v),
                    activeColor: Colors.white, activeTrackColor: const Color(0xFF8B5CF6),
                    inactiveThumbColor: Colors.white38, inactiveTrackColor: Colors.white12)),
              _SectionLabel('PROFILE'),
              _SettingsTile(title: 'First Name', subtitle: 'Seya', bold: true, trailing: const Icon(Icons.chevron_right, color: Colors.white38)),
              _SectionLabel('COMPANION'),
              _SettingsTile(title: 'Sage', subtitle: 'Your reflection companion'),
              _SectionLabel('NOTIFICATIONS'),
              _SettingsTile(leading: const Icon(Icons.notifications_none, color: Colors.white60, size: 20),
                title: 'Remind me to check in',
                trailing: Switch(value: _notifications, onChanged: (v) => setState(() => _notifications = v),
                    activeColor: Colors.white, activeTrackColor: const Color(0xFF8B5CF6),
                    inactiveThumbColor: Colors.white38, inactiveTrackColor: Colors.white12)),
              _SectionLabel('DATA'),
              _SettingsTile(title: 'Export all sessions', trailing: const Icon(Icons.chevron_right, color: Colors.white38)),
              _SectionLabel('ACCOUNT ACTIONS', color: const Color(0xFFEF4444)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(color: const Color(0xFF1C0810), borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.25))),
                  child: Column(children: [
                    _ActionRow(label: 'Log out', onTap: () => Navigator.pushReplacementNamed(context, '/login')),
                    Divider(height: 1, color: const Color(0xFFEF4444).withOpacity(0.15), indent: 16, endIndent: 16),
                    _ActionRow(label: 'Delete account'),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text; final Color color;
  const _SectionLabel(this.text, {this.color = const Color(0xFF7A7A9A)});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
    child: Text(text, style: GoogleFonts.inter(color: color, fontSize: 11, letterSpacing: 1.4, fontWeight: FontWeight.w600)),
  );
}

class _SettingsTile extends StatelessWidget {
  final Widget? leading; final String title; final String? subtitle;
  final Widget? trailing; final bool bold; final VoidCallback? onTap;
  const _SettingsTile({this.leading, required this.title, this.subtitle, this.trailing, this.bold = false, this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.07))),
      child: Row(children: [
        if (leading != null) ...[leading!, const SizedBox(width: 12)],
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: bold ? FontWeight.w600 : FontWeight.normal)),
          if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle!, style: GoogleFonts.inter(color: Colors.white38, fontSize: 12))],
        ])),
        if (trailing != null) trailing!,
      ]),
    ),
  );
}

class _ActionRow extends StatelessWidget {
  final String label; final VoidCallback? onTap;
  const _ActionRow({required this.label, this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: GoogleFonts.inter(color: const Color(0xFFEF4444), fontSize: 15)),
        const Icon(Icons.chevron_right, color: Color(0xFFEF4444), size: 20),
      ]),
    ),
  );
}
