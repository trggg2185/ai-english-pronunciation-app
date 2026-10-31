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
/// Bảng màu chuẩn của ứng dụng luyện phát âm AI
class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF2563EB); // Royal Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFDBEAFE);
  static const Color accent = Color(0xFF8B5CF6); // Purple Accent

  // Phoneme & Pronunciation Evaluation Colors (Theo README: Xanh >= 80, Vàng >= 50, Đỏ < 50)
  static const Color correctGreen = Color(0xFF10B981); // 🟢 Xanh lá (>= 80)
  static const Color correctGreenLight = Color(0xFFD1FAE5);
  static const Color acceptableYellow = Color(0xFFF59E0B); // 🟡 Vàng (>= 50)
  static const Color acceptableYellowLight = Color(0xFFFEF3C7);
  static const Color wrongRed = Color(0xFFEF4444); // 🔴 Đỏ (< 50)
  static const Color wrongRedLight = Color(0xFFFEE2E2);

  // Backgrounds & Neutrals
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color cardShadow = Color(0x0F000000);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);

  // Audio Waveform Colors
  static const Color userWaveform = Color(0xFF3B82F6);
  static const Color nativeWaveform = Color(0xFF10B981);
  static const Color pitchError = Color(0xFFEF4444);

  /// Trả về màu tương ứng theo điểm số (0 - 100)
  static Color getScoreColor(double score) {
    if (score >= 80) return correctGreen;
    if (score >= 50) return acceptableYellow;
    return wrongRed;
  }

  /// Trả về màu nền nhạt cho điểm số
  static Color getScoreBackgroundColor(double score) {
    if (score >= 80) return correctGreenLight;
    if (score >= 50) return acceptableYellowLight;
    return wrongRedLight;
  }
}

