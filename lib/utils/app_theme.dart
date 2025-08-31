import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF000000);
  static const Color accentColor = Color(0xFFED145B);
  static const Color background = Color(0xFFF8F8F8);

  static const Color tileColorOrange = Color(0xFFFFE3B3);
  static const Color tileColorRed = Color(0xFFFFC5C5);
  static const Color tileColorPink = Color(0xFFF9C5EB);
  static const Color tileColorPurple = Color(0xFFE2C9FF);
  static const Color tileColorBlue = Color(0xFFC8D8FF);
  static const Color tileColorGreen = Color(0xFFCFF9DA);
  static const Color tileColorLightBlue = Color(0xFFD0F1FF);

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: background,
        surfaceContainerHighest: Colors.white,
        onPrimary: primaryColor,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryColor,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
      iconTheme: const IconThemeData(color: primaryColor),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
