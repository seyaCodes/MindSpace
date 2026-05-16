import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum MindSpaceButtonVariant { primary, secondary, destructive }

class MindSpaceButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final MindSpaceButtonVariant variant;
  final Widget? leading;
  final bool isLoading;

  const MindSpaceButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = MindSpaceButtonVariant.primary,
    this.leading,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: switch (variant) {
        MindSpaceButtonVariant.primary => _buildPrimary(),
        MindSpaceButtonVariant.secondary => _buildSecondary(),
        MindSpaceButtonVariant.destructive => _buildDestructive(),
      },
    );
  }

  Widget _buildPrimary() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [AppColors.accentPurple, AppColors.accentBlue],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: isLoading ? null : onPressed,
        child: _content(Colors.white),
      ),
    );
  }

  Widget _buildSecondary() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: AppColors.bgElevated,
      ),
      onPressed: isLoading ? null : onPressed,
      child: _content(AppColors.textPrimary),
    );
  }

  Widget _buildDestructive() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accentRed,
        side: const BorderSide(color: AppColors.accentRed, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.transparent,
      ),
      onPressed: isLoading ? null : onPressed,
      child: _content(AppColors.accentRed),
    );
  }

  Widget _content(Color textColor) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: AppSpacing.sm)],
        Text(
          label,
          style: GoogleFonts.inter(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
