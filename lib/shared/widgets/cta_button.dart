import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mind_space/core/theme/app_theme.dart';

class CtaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;

  const CtaButton({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          gradient: onTap != null
              ? AppGradients.cta
              : const LinearGradient(
                  colors: [Color(0xFF4A4A6A), Color(0xFF4A4A6A)],
                ),
          borderRadius: BorderRadius.circular(32),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.black87),
                ),
              )
            : Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }
}

