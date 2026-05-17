import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../core/widgets/pressable_scale.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1340),
      body: Stack(
        children: [
          Container(
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
          ),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Profile',
                            style: GoogleFonts.inter(
                                color: AppColors.textPrimary, fontSize: 28,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('Tune your space and your boundaries.',
                            style: GoogleFonts.inter(
                                color: AppColors.textSecondary, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                // Profile card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52, height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentPurple.withOpacity(0.2),
                              border: Border.all(
                                  color: AppColors.accentPurple.withOpacity(0.4),
                                  width: 1),
                            ),
                            alignment: Alignment.center,
                            child: Text('S',
                                style: GoogleFonts.inter(
                                    color: AppColors.accentPurple, fontSize: 22,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Seya',
                                    style: GoogleFonts.inter(
                                        color: AppColors.textPrimary, fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text('42 sessions · 4 active arcs · 17-day streak',
                                    style: GoogleFonts.inter(
                                        color: AppColors.textSecondary,
                                        fontSize: 12)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.accentGreen.withOpacity(0.4),
                                        width: 1),
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.full),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6, height: 6,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.accentGreen,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text('KEEPING A QUIET PRACTICE',
                                          style: GoogleFonts.inter(
                                              color: AppColors.accentGreen,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.8)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // YOUR SPACE section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text('YOUR SPACE',
                        style: GoogleFonts.inter(
                            color: AppColors.textTertiary, fontSize: 11,
                            fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _SettingsGroup(rows: [
                      _SettingsRow(
                        icon: Icons.add,
                        title: "Sage's tone",
                        subtitle: 'Soft · curious · gently challenging',
                        trailing: _TrailingText('Soft ›'),
                      ),
                      _SettingsRow(
                        icon: Icons.radio_button_checked_outlined,
                        title: 'Aurora palette',
                        subtitle: 'Color the app to the dominant emotion',
                        trailing: _ComingSoonSwitch(value: true),
                      ),
                      _SettingsRow(
                        icon: Icons.nightlight_outlined,
                        title: 'Quiet hours',
                        subtitle: 'No nudges between 10 PM and 7 AM',
                        trailing: _TrailingText('On ›'),
                      ),
                    ]),
                  ),
                ),
                // PRACTICE section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text('PRACTICE',
                        style: GoogleFonts.inter(
                            color: AppColors.textTertiary, fontSize: 11,
                            fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _SettingsGroup(rows: [
                      _SettingsRow(
                        icon: Icons.access_time_outlined,
                        title: 'Daily check-in nudge',
                        subtitle: '9 PM · the spike window',
                        trailing: _TrailingText('9:00 PM ›'),
                      ),
                      _SettingsRow(
                        icon: Icons.delete_outline,
                        title: 'Auto-archive arcs',
                        subtitle: 'After 30 days of silence',
                        trailing: _ComingSoonSwitch(value: false),
                      ),
                      _SettingsRow(
                        icon: Icons.auto_awesome_outlined,
                        title: 'ML-assisted clustering',
                        subtitle: 'Let Sage group sessions automatically',
                        trailing: _ComingSoonBadge(),
                      ),
                    ]),
                  ),
                ),
                // PRIVACY section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text('PRIVACY',
                        style: GoogleFonts.inter(
                            color: AppColors.textTertiary, fontSize: 11,
                            fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _SettingsGroup(rows: [
                      _SettingsRow(
                        icon: Icons.lock_outline,
                        title: 'Export my data',
                        subtitle: 'Download all your sessions as JSON',
                        trailing: const Icon(Icons.chevron_right,
                            color: AppColors.textTertiary, size: 18),
                      ),
                      _SettingsRow(
                        icon: Icons.logout,
                        title: 'Sign out',
                        subtitle: null,
                        trailing: null,
                        destructive: true,
                      ),
                    ]),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsRow> rows;
  const _SettingsGroup({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: List.generate(rows.length, (i) => Column(
          children: [
            rows[i],
            if (i < rows.length - 1)
              Divider(height: 0, thickness: 0.5, color: AppColors.border,
                  indent: 52, endIndent: 0),
          ],
        )),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool destructive;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.destructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: destructive
                    ? AppColors.accentRed.withOpacity(0.12)
                    : AppColors.bgElevated,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon,
                  size: 16,
                  color: destructive ? AppColors.accentRed : AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          color: destructive
                              ? AppColors.accentRed
                              : AppColors.textPrimary,
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: GoogleFonts.inter(
                            color: AppColors.textTertiary, fontSize: 12)),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _TrailingText extends StatelessWidget {
  final String text;
  const _TrailingText(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 13));
}

class _ComingSoonSwitch extends StatelessWidget {
  final bool value;
  const _ComingSoonSwitch({required this.value});
  @override
  Widget build(BuildContext context) => Switch(
        value: value,
        onChanged: null,
        activeColor: AppColors.accentPurple,
      );
}

class _ComingSoonBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.accentPurple.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
              color: AppColors.accentPurple.withOpacity(0.3), width: 0.5),
        ),
        child: Text('Soon',
            style: GoogleFonts.inter(
                color: AppColors.accentPurple, fontSize: 10,
                fontWeight: FontWeight.w600)),
      );
}
