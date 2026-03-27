import 'package:flutter/material.dart';

/// Design tokens — colors for the Prep Chinese Vocab app.
class AppColors {
  const AppColors._();

  // Brand
  static const Color primary = Color(0xFF6366F1);       // Indigo-500
  static const Color primaryLight = Color(0xFF818CF8);   // Indigo-400
  static const Color primaryDark = Color(0xFF4F46E5);    // Indigo-600

  // Accent
  static const Color accent = Color(0xFFF59E0B);         // Amber-500
  static const Color accentLight = Color(0xFFFBBF24);    // Amber-400

  // Semantic
  static const Color success = Color(0xFF22C55E);        // Green-500
  static const Color warning = Color(0xFFF59E0B);        // Amber-500
  static const Color error = Color(0xFFEF4444);          // Red-500
  static const Color info = Color(0xFF3B82F6);           // Blue-500

  // Neutral — light theme
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color borderLight = Color(0xFFE5E7EB);

  // Neutral — dark theme
  static const Color backgroundDark = Color(0xFF111827);
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color borderDark = Color(0xFF374151);

  // HSK level colors (for the HSK grid)
  static const List<Color> hskLevelColors = [
    Color(0xFF22C55E), // HSK 1 — Green
    Color(0xFF3B82F6), // HSK 2 — Blue
    Color(0xFF8B5CF6), // HSK 3 — Violet
    Color(0xFFF59E0B), // HSK 4 — Amber
    Color(0xFFEF4444), // HSK 5 — Red
    Color(0xFFEC4899), // HSK 6 — Pink
    Color(0xFF6366F1), // HSK 7 — Indigo
    Color(0xFF14B8A6), // HSK 8 — Teal
    Color(0xFF78716C), // HSK 9 — Stone
  ];

  // Pinyin tone colors (for tone-colored display)
  static const Color tone1 = Color(0xFFEF4444); // Red — flat high
  static const Color tone2 = Color(0xFFF59E0B); // Amber — rising
  static const Color tone3 = Color(0xFF22C55E); // Green — dipping
  static const Color tone4 = Color(0xFF3B82F6); // Blue — falling
  static const Color tone5 = Color(0xFF9CA3AF); // Gray — neutral

  // Confidence levels (OCR)
  static const Color confidenceHigh = Color(0xFF22C55E);
  static const Color confidenceMedium = Color(0xFFF59E0B);
  static const Color confidenceLow = Color(0xFFEF4444);

  // Pro badge
  static const Color proBadge = Color(0xFFF59E0B);
}
