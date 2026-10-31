import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF2563EB); // Royal Blue
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color accent = Color(0xFFF59E0B); // Amber / Fire streak

  // Streak & Discipline colors
  static const Color fireActive = Color(0xFFFF6D00);
  static const Color fireInactive = Color(0xFF9E9E9E);
  static const Color streakBackground = Color(0xFFFFF3E0);

  // Status colors for pronunciation
  static const Color correct = Color(0xFF10B981); // Emerald Green
  static const Color acceptable = Color(0xFFFBBF24); // Warm Amber
  static const Color wrong = Color(0xFFEF4444); // Crimson Red

  // Background & surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
}
