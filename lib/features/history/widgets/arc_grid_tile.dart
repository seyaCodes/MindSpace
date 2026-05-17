import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';

class ArcGridTile extends StatefulWidget {
  final String folderAsset;
  final String name;
  final int? sessionCount;
  final String? subtitle;
  final List<Color> spiritDots;
  final bool archived;
  final VoidCallback? onTap;

  const ArcGridTile({
    super.key,
    required this.folderAsset,
    required this.name,
    this.sessionCount,
    this.subtitle,
    this.spiritDots = const [],
    this.archived = false,
    this.onTap,
  });

  @override
  State<ArcGridTile> createState() => _ArcGridTileState();
}

class _ArcGridTileState extends State<ArcGridTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    reverseDuration: const Duration(milliseconds: 150),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.97)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        HapticFeedback.selectionClick();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Opacity(
          opacity: widget.archived ? 0.5 : 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.13),
                      Colors.white.withOpacity(0.04),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.20),
                    width: 0.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: LayoutBuilder(
                  builder: (_, constraints) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Label area — top 45% ──────────────────────
                      SizedBox(
                        height: constraints.maxHeight * 0.45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: widget.archived
                                    ? AppColors.textTertiary
                                    : AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.subtitle ??
                                  '${widget.sessionCount} sessions',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (widget.spiritDots.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: widget.spiritDots
                                    .map((c) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: c,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // ── Folder illustration — bottom ──────────────
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxHeight: 90),
                            child: Image.asset(
                              widget.folderAsset,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
