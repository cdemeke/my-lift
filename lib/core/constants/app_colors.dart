import 'package:flutter/material.dart';

/// App color palette for MyLift.
/// Uses a fitness-focused color scheme with energetic primary colors.
class AppColors {
  AppColors._();

  // Primary colors - energetic blue/teal
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Secondary colors - vibrant orange for accents
  static const Color secondary = Color(0xFFF97316);
  static const Color secondaryLight = Color(0xFFFB923C);
  static const Color secondaryDark = Color(0xFFEA580C);

  // Success/completion colors
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF4ADE80);
  static const Color successDark = Color(0xFF16A34A);

  // Warning colors
  static const Color warning = Color(0xFFFBBF24);
  static const Color warningLight = Color(0xFFFCD34D);
  static const Color warningDark = Color(0xFFF59E0B);

  // Error colors
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Background colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1F2937);

  // Muscle group colors (for UI visualization)
  static const Color chest = Color(0xFFEF4444);
  static const Color back = Color(0xFF3B82F6);
  static const Color shoulders = Color(0xFFF97316);
  static const Color arms = Color(0xFF8B5CF6);
  static const Color legs = Color(0xFF22C55E);
  static const Color core = Color(0xFFFBBF24);
  static const Color cardio = Color(0xFFEC4899);

  // Workout status colors
  static const Color statusPending = Color(0xFF9CA3AF);
  static const Color statusInProgress = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF22C55E);
  static const Color statusSkipped = Color(0xFFF97316);
}
