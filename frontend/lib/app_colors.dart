import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF6366F1); // Indigo
  static const Color secondaryLight = Color(0xFF8B5CF6); // Purple
  static const Color tertiaryLight = Color(0xFF3B82F6); // Blue
  static const Color accentLight = Color(0xFF06B6D4); // Cyan

  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1F2937);
  static const Color lightHint = Color(0xFF9CA3AF);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF818CF8); // Light Indigo
  static const Color secondaryDark = Color(0xFFA78BFA); // Light Purple
  static const Color tertiaryDark = Color(0xFF60A5FA); // Light Blue
  static const Color accentDark = Color(0xFF22D3EE); // Light Cyan

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkHint = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF475569);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Demand Level Colors
  static const Color demandVeryHigh = Color(0xFF10B981); // Green
  static const Color demandHigh = Color(0xFF3B82F6); // Blue
  static const Color demandMedium = Color(0xFFF59E0B); // Amber
  static const Color demandLow = Color(0xFFEF4444); // Red

  // Role Colors
  static const Color studentColor = Color(0xFF06B6D4);
  static const Color parentColor = Color(0xFF8B5CF6);
  static const Color adminColor = Color(0xFFF59E0B);

  // Gradients for Light Theme
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [primaryLight, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradients for Dark Theme
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [primaryDark, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Backward Compatibility - Default to Light Theme colors
  static const Color primary = primaryLight;
  static const Color secondary = secondaryLight;
  static const Color tertiary = tertiaryLight;
  static const Color accent = accentLight;
}
