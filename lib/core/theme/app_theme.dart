import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDeep,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.orbLavender,
        secondary: AppColors.accentTeal,
        surface: AppColors.bgDeep,
      ),
      textTheme: _textTheme(),
      useMaterial3: true,
    );
  }

  static TextTheme _textTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.dmSans(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.dmSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
        height: 1.15,
      ),
      headlineMedium: GoogleFonts.dmSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.5,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textSubtle,
        letterSpacing: 1.4,
      ),
    );
  }
}

abstract class AppColors {
  // Backgrounds
  static const bgDeep    = Color(0xFF0D1B3E);
  static const bgMid     = Color(0xFF1A1F4E);
  static const bgCard    = Color(0xFF1E2456);

  // Orb
  static const orbLavender  = Color(0xFF9B8FD4);
  static const orbLight     = Color(0xFFBEB3E8);

  // Accents
  static const accentTeal   = Color(0xFF6EECD4);
  static const accentBlue   = Color(0xFF74B9FF);
  static const accentPurple = Color(0xFF9B7FD4);

  // Text
  static const white      = Color(0xFFFFFFFF);
  static const textMuted  = Color(0xFFB0B8D4);
  static const textSubtle = Color(0xFF6B7494);

  // Gradient stops
  static const gradTopLeft     = Color(0xFF4B2D8F);
  static const gradBottomRight = Color(0xFF0D1B3E);

  // CTA button gradient
  static const ctaLeft  = Color(0xFFA78BCA);
  static const ctaRight = Color(0xFF6EECD4);
}

abstract class AppGradients {
  static const background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gradTopLeft, AppColors.gradBottomRight],
    stops: [0.0, 0.65],
  );

  static const cta = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.ctaLeft, AppColors.ctaRight],
  );
}

