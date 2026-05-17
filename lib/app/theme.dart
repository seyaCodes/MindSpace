import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Color tokens ──────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Backgrounds
  static const bgPrimary   = Color(0xFF0D0D1A);
  static const bgCard      = Color(0xFF151528);
  static const bgElevated  = Color(0xFF1C1C35);

  // Text
  static const textPrimary   = Color(0xFFF5F5F7);
  static const textSecondary = Color(0xFF9B9BA0);
  static const textTertiary  = Color(0xFF5A5A60);

  // Accents
  static const accentPurple = Color(0xFF6C5CE7);
  static const accentGreen  = Color(0xFF00C48C);
  static const accentOrange = Color(0xFFF39C12);
  static const accentBlue   = Color(0xFF5B8DEF);
  static const accentRed    = Color(0xFFE74C3C);
  static const accentTeal        = Color(0xFF26B7CD);
  static const accentHopeful     = Color(0xFFA8E063);
  static const accentOverwhelmed = Color(0xFFE17055);

  // Borders
  static const border       = Color(0xFF2A2A2E);
  static const borderSubtle = Color(0xFF1C1F3A);

  // Home gradient
  static const homeGradientTop    = Color(0xFF2D1B69);
  static const homeGradientBottom = Color(0xFF0D0D1A);

  // Background gradient stops
  static const bgTop    = Color(0xFF3D2B7A);
  static const bgMid    = Color(0xFF1A1F5E);
  static const bgBottom = Color(0xFF0E1340);

  // Emotion colors
  static const emotionAnxious     = Color(0xFF6C5CE7);
  static const emotionCalm        = Color(0xFF00C48C);
  static const emotionSad         = Color(0xFF5B8DEF);
  static const emotionFrustrated  = Color(0xFFF39C12);
  static const emotionHappy       = Color(0xFFA8E063);
  static const emotionAngry       = Color(0xFFE74C3C);
  static const emotionNumb        = Color(0xFF9B9BA0);

  // Chat bubble colors
  static const bubbleSage = Color(0xFF1E2260);
  static const bubbleUser = Color(0xFF2D2B6B);
}

// ── Spacing tokens ────────────────────────────────────────────────────────────
class AppSpacing {
  AppSpacing._();
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
}

// ── Radius tokens ─────────────────────────────────────────────────────────────
class AppRadius {
  AppRadius._();
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 20.0;
  static const double xxl  = 28.0;
  static const double full = 999.0;
}

// ── ThemeData ─────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentPurple,
          secondary: AppColors.accentTeal,
          surface: AppColors.bgCard,
          error: AppColors.accentRed,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      );
}
