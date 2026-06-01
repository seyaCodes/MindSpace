import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/arc_providers.dart';
import '../../data/repositories/arc_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../shared/widgets/app_background.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

    final profileAsync = ref.watch(_profileProvider(userId));

    return AppBackground(
      child: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.orbLavender,
            ),
          ),
          error: (_, __) => const Center(
            child: Text(
              'Something went wrong.',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          data: (profile) => _HomeBody(
            displayName: profile?.displayName ?? 'there',
          ),
        ),
      ),
    );
  }
}

final _profileProvider = FutureProvider.family<ProfileModel?, String>(
  (ref, userId) async {
    if (userId.isEmpty) return null;
    return ref.read(profileRepositoryProvider).fetchProfile(userId);
  },
);

class _HomeBody extends ConsumerWidget {
  final String displayName;

  const _HomeBody({required this.displayName});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  String get _dateLabel {
    final now = DateTime.now();

    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];

    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arcsAsync = ref.watch(arcsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _dateLabel,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSubtle,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          _GreetingText(greeting: _greeting, name: displayName),
          const SizedBox(height: 8),
          Text(
            'Pick up where you left off, or start fresh.',
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your arcs',
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () => context.go(AppRoutes.history),
                child: Text(
                  'view all ›',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.accentPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          arcsAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.orbLavender),
            ),
            error: (_, __) => _ArcGrid(arcs: const []),
            data: (arcs) => _ArcGrid(arcs: arcs),
          ),
        ],
      ),
    );
  }
}

class _GreetingText extends StatelessWidget {
  final String greeting;
  final String name;

  const _GreetingText({required this.greeting, required this.name});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$greeting,\n',
            style: GoogleFonts.dmSans(
              fontSize: 52,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          TextSpan(
            text: '$name.',
            style: GoogleFonts.dmSans(
              fontSize: 52,
              fontWeight: FontWeight.w800,
              color: AppColors.orbLavender.withOpacity(.6),
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcGrid extends StatelessWidget {
  final List<ArcModel> arcs;

  const _ArcGrid({required this.arcs});

  @override
  Widget build(BuildContext context) {
    final cellSize = (MediaQuery.of(context).size.width - 48 - 12) / 2;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: .82,
      children: [
        ...arcs.map((arc) => _ArcCard(arc: arc)),
        _NewThreadCell(size: cellSize),
      ],
    );
  }
}

class _ArcCard extends StatelessWidget {
  final ArcModel arc;

  const _ArcCard({required this.arc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.arcDetail}/${arc.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.orbLavender.withOpacity(.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orbLavender.withOpacity(.15),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppColors.orbLavender,
                size: 18,
              ),
            ),
            const Spacer(),
            Text(
              arc.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${arc.sessionCount} ${arc.sessionCount == 1 ? 'session' : 'sessions'}',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: AppColors.textSubtle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewThreadCell extends StatelessWidget {
  final double size;

  const _NewThreadCell({required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.chat),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size * .72,
            height: size * .72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white24,
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              color: Colors.white.withOpacity(.04),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white38,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'New Thread',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
