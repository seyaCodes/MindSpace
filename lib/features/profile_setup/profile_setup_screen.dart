import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import 'package:mind_space/shared/widgets/app_background.dart';
import 'package:mind_space/shared/widgets/cta_button.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _loading = false;
  String? _error;

  static const int _maxLength = 24;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _name => _controller.text.trim();
  bool get _canSubmit => _name.isNotEmpty && !_loading;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(profileRepositoryProvider).upsertDisplayName(
            userId: userId,
            displayName: _name,
          );
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (_) {
      setState(() {
        _loading = false;
        _error = 'Could not save your name. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AppBackground(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => context.go(AppRoutes.auth),
                    icon: const Icon(Icons.chevron_left_rounded,
                        color: Colors.white70, size: 20),
                    label: Text(
                      'Back',
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _focusNode.unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      _AvatarBadge(
                        initial: _name.isEmpty ? 'S' : _name[0].toUpperCase(),
                      ),
                      const SizedBox(height: 40),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'What should Sage ',
                              style: GoogleFonts.dmSans(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: 'call\nyou?',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 30,
                                fontStyle: FontStyle.italic,
                                color: AppColors.accentPurple,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Just a first name is perfect. You can\nchange it anytime in settings.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: AppColors.textMuted,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _NameField(
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLength: _maxLength,
                        onSubmitted: (_) => _submit(),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                12,
                24,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              child: CtaButton(
                label: 'Enter Mind Space →',
                loading: _loading,
                onTap: _canSubmit ? _submit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  final String initial;
  const _AvatarBadge({required this.initial});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment(-0.3, -0.3),
              radius: 0.85,
              colors: [
                AppColors.orbLight,
                AppColors.orbLavender,
                Color(0xFF6A5ACD),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Center(
            child: Text(
              initial,
              style: GoogleFonts.dmSans(
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1A1A2E),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxLength;
  final ValueChanged<String> onSubmitted;

  const _NameField({
    required this.controller,
    required this.focusNode,
    required this.maxLength,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              maxLength: maxLength,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-']")),
              ],
              onSubmitted: onSubmitted,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                counterText: '',
                hintText: 'Your name',
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: AppColors.textSubtle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '${controller.text.trim().length} / $maxLength',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: AppColors.textSubtle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
