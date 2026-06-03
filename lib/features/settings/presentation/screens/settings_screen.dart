import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/profile_repository.dart';
import 'package:mind_space/shared/widgets/app_background.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    final profileAsync = ref.watch(_settingsProfileProvider(userId));

    return AppBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Text(
                  'Settings',
                  style: GoogleFonts.dmSans(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              profileAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.orbLavender,
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
                data: (profile) => _ProfileTile(
                  name: profile?.displayName ?? '—',
                  email:
                      Supabase.instance.client.auth.currentUser?.email ?? '—',
                  memberSince: profile?.createdAt,
                ),
              ),
              const SizedBox(height: 28),
              _SectionHeader(label: 'Privacy & Data'),
              _SettingsRow(
                icon: Icons.delete_outline_rounded,
                iconColor: Colors.redAccent,
                title: 'Delete my data',
                subtitle: 'Removes all chats, reflections, and arcs',
                onTap: () => _confirmDataDeletion(context, ref),
              ),
              const SizedBox(height: 20),
              _SectionHeader(label: 'Legal'),
              _SettingsRow(
                icon: Icons.shield_outlined,
                title: 'Privacy Policy',
                onTap: () => _showLegal(
                  context,
                  'Privacy Policy',
                  _kPrivacyPolicy,
                ),
              ),
              _SettingsRow(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () => _showLegal(
                  context,
                  'Terms of Service',
                  _kTermsOfService,
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: _SignOutButton(
                  onTap: () async {
                    await Supabase.instance.client.auth.signOut();
                    if (context.mounted) context.go(AppRoutes.auth);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDataDeletion(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Delete all your data?',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: Text(
          'This will permanently remove your profile, chats, reflections, '
          'and arcs. Data in active records is deleted immediately; backup '
          'retention is up to 30 days per our data policy.\n\nThis action '
          'cannot be undone.',
          style: GoogleFonts.dmSans(
            color: AppColors.textMuted,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _deleteUserData(context);
            },
            child: Text(
              'Delete everything',
              style: GoogleFonts.dmSans(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUserData(BuildContext context) async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    // Show loading overlay
    if (context.mounted) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _DeletionLoadingDialog(),
      );
    }

    try {
      // 1. Get chat IDs to remove messages (FK child of chats)
      final chatsResult = await client
          .from('chats')
          .select('id')
          .eq('user_id', userId);
      final chatIds = (chatsResult as List)
          .map((c) => c['id'] as String)
          .toList();

      if (chatIds.isNotEmpty) {
        await client
            .from('messages')
            .delete()
            .inFilter('chat_id', chatIds);
      }

      // 2. Delete reflections
      await client.from('reflections').delete().eq('user_id', userId);

      // 3. Get arc IDs to remove arc_insights (FK child of arcs)
      final arcsResult = await client
          .from('arcs')
          .select('id')
          .eq('user_id', userId);
      final arcIds = (arcsResult as List)
          .map((a) => a['id'] as String)
          .toList();

      if (arcIds.isNotEmpty) {
        await client
            .from('arc_insights')
            .delete()
            .inFilter('arc_id', arcIds);
      }

      // 4. Delete chats and arcs
      await client.from('chats').delete().eq('user_id', userId);
      await client.from('arcs').delete().eq('user_id', userId);

      // 5. Delete profile last (auth-linked row)
      await client.from('profiles').delete().eq('id', userId);

      // 6. Sign out
      await client.auth.signOut();

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // close loading
        context.go(AppRoutes.auth);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not delete data. Please try again.',
              style: GoogleFonts.dmSans(),
            ),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    }
  }

  void _showLegal(BuildContext context, String title, String body) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LegalSheet(title: title, body: body),
    );
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────

final _settingsProfileProvider =
    FutureProvider.family<ProfileModel?, String>((ref, userId) async {
  if (userId.isEmpty) return null;
  return ref.read(profileRepositoryProvider).fetchProfile(userId);
});

// ─── Widgets ─────────────────────────────────────────────────────────────────

class _ProfileTile extends StatelessWidget {
  final String name;
  final String email;
  final DateTime? memberSince;

  const _ProfileTile({
    required this.name,
    required this.email,
    this.memberSince,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFC89BFF), Color(0xFFA970FF)],
                ),
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: GoogleFonts.dmSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.dmSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (memberSince != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Member since ${_formatDate(memberSince!)}',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: AppColors.textSubtle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSubtle,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 3),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(.06)),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor ?? AppColors.textMuted,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: iconColor != null
                            ? iconColor!.withOpacity(.9)
                            : Colors.white,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: AppColors.textSubtle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textSubtle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeletionLoadingDialog extends StatelessWidget {
  const _DeletionLoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.orbLavender),
            const SizedBox(height: 20),
            Text(
              'Deleting your data…',
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'This may take a moment.',
              style: GoogleFonts.dmSans(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalSheet extends StatelessWidget {
  final String title;
  final String body;

  const _LegalSheet({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.bgMid,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.white12,
              height: 1,
              indent: 24,
              endIndent: 24,
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                children: [
                  Text(
                    body,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SignOutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(.2)),
        ),
        child: Text(
          'Sign out',
          style: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}

// ─── Legal copy ──────────────────────────────────────────────────────────────

const _kPrivacyPolicy = '''
Last updated: June 2026

MindSpace is a private reflection app. We take your privacy seriously.

Data we collect
We collect your email address (used only for authentication), your chosen display name, and the content you create within the app — including conversations with Sage, session reflections, and life arcs.

How we use your data
Your data is used exclusively to provide the MindSpace experience: generating post-session reflections, building your arc history, and personalising your interactions with Sage. We do not use your data for advertising.

Data storage
All data is stored securely via Supabase. Conversations and reflections are processed through AI models (Groq / LLaMA) solely to generate your in-app content. No conversation content is retained by third-party AI providers beyond the duration of the API call.

Data sharing
We do not sell, rent, or share your personal data with any third party, except as required by law.

Data deletion
You may request deletion of all your data at any time through Settings → Delete my data. Active records (profile, chats, reflections, arcs) are removed immediately. Encrypted backups may be retained for up to 30 days before permanent purge.

Contact
For any privacy concerns, contact us at the address provided in your institution.
''';

const _kTermsOfService = '''
Last updated: June 2026

By using MindSpace, you agree to the following terms.

Nature of the service
MindSpace is a personal reflection tool. It is not a medical service, a mental health clinic, or a substitute for professional therapy or counselling. Sage is an AI companion — it does not diagnose, prescribe, or provide clinical support.

Crisis situations
If you are experiencing a mental health crisis or are in danger, please contact a qualified professional or emergency services immediately. MindSpace is not equipped to respond to emergencies.

Acceptable use
You agree to use MindSpace for personal, non-commercial reflection purposes only. You must not attempt to misuse, reverse-engineer, or disrupt the service.

Content
The reflections and conversations you create are yours. You retain ownership of your content. By using the service, you grant us the limited right to process that content in order to deliver the app's features.

Changes
We may update these terms as the service evolves. Continued use after an update constitutes acceptance of the revised terms.

Limitation of liability
MindSpace is provided as-is. We are not liable for outcomes arising from use of the app, including decisions made based on Sage's responses.
''';
