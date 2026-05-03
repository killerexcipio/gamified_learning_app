import 'package:flutter/material.dart';

class RbColors {
  static const darkShell = Color(0xFF1D3030);
  static const darkNav = Color(0xFF172928);
  static const accent = Color(0xFF00A7B5);
  static const accentDark = Color(0xFF007B85);
  static const pageBg = Color(0xFFF4F6F8);
  static const card = Color(0xFFFFFFFF);
  static const text = Color(0xFF1E2A2A);
  static const muted = Color(0xFF6B7777);
  static const danger = Color(0xFFE55353);
  static const success = Color(0xFF20A36B);
  static const warning = Color(0xFFF5A524);
  static const paleTeal = Color(0xFFE6F8FA);
}

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: RbColors.accent,
      primary: RbColors.accent,
      secondary: RbColors.accentDark,
      surface: RbColors.card,
      background: RbColors.pageBg,
      error: RbColors.danger,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: RbColors.pageBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: RbColors.darkShell,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: RbColors.card,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: RbColors.paleTeal,
      labelStyle: const TextStyle(color: RbColors.text),
      side: BorderSide(color: Colors.grey.shade300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: RbColors.accent, width: 2),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: RbColors.accent,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: RbColors.text),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: RbColors.text),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: RbColors.text),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: RbColors.text),
      bodyLarge: TextStyle(fontSize: 16, color: RbColors.text, height: 1.45),
      bodyMedium: TextStyle(fontSize: 14, color: RbColors.text, height: 1.4),
      labelMedium: TextStyle(fontSize: 12, color: RbColors.muted, fontWeight: FontWeight.w600),
    ),
  );
}
