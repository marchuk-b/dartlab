import 'package:flutter/material.dart';

class AppColors {
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkPrimary = Color(0xFF1E1E1E);
  static const Color darkSecondary = Color(0xFF2D2D2D);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xB3FFFFFF);
  static const Color darkTextDisabled = Color(0x61FFFFFF);

  static const Color darkIcon = Color(0xFFFFFFFF);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFFF5F5F5);
  static const Color lightSecondary = Color(0xFFE0E0E0);

  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0x99000000);
  static const Color lightTextDisabled = Color(0x61000000);

  static const Color lightIcon = Color(0xFF000000);

  // Shared Colors (однакові для обох тем)
  static const Color accentColor = Color(0xFF4A9EFF);
  static const Color errorColor = Color(0xFFCF6679);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color activeButton = Colors.deepPurple;
  static const Color activeSlider = Colors.deepPurple;
  static const Color activeArrow = Colors.deepPurple;
  static Color disabledArrow = Colors.deepPurple.withValues(alpha: 0.3);

  // Геттери для поточної теми
  static Color backgroundColor(bool isDark) =>
      isDark ? darkBackground : lightBackground;

  static Color primaryColor(bool isDark) =>
      isDark ? darkPrimary : lightPrimary;

  static Color secondaryColor(bool isDark) =>
      isDark ? darkSecondary : lightSecondary;

  static Color textPrimary(bool isDark) =>
      isDark ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;

  static Color textDisabled(bool isDark) =>
      isDark ? darkTextDisabled : lightTextDisabled;

  static Color iconColor(bool isDark) =>
      isDark ? darkIcon : lightIcon;

  static Color appBarColor(bool isDark) =>
      isDark ? darkPrimary : lightPrimary;

  static Color bottomBarColor(bool isDark) =>
      isDark ? darkPrimary : lightPrimary;
}