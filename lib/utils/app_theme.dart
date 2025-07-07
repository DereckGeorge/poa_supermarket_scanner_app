import 'package:flutter/material.dart';

class AppTheme {
  // Color constants
  static const Color primaryRed = Color(0xFFE53E3E);
  static const Color darkRed = Color(0xFFC53030);
  static const Color lightRed = Color(0xFFFEB2B2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFF7FAFC);
  static const Color darkGrey = Color(0xFF2D3748);
  static const Color textGrey = Color(0xFF4A5568);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: MaterialColor(0xFFE53E3E, <int, Color>{
        50: Color(0xFFFEB2B2),
        100: Color(0xFFFEB2B2),
        200: Color(0xFFFC8181),
        300: Color(0xFFF56565),
        400: Color(0xFFED8936),
        500: Color(0xFFE53E3E),
        600: Color(0xFFDD6B20),
        700: Color(0xFFC53030),
        800: Color(0xFF9C4221),
        900: Color(0xFF744210),
      }),
      primaryColor: primaryRed,
      scaffoldBackgroundColor: white,
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: darkGrey,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkGrey,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: darkGrey),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryRed,
        unselectedItemColor: textGrey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: white, elevation: 8),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryRed,
          side: const BorderSide(color: primaryRed),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: textGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: textGrey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: darkGrey,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: darkGrey,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: darkGrey,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: darkGrey,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: textGrey,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: textGrey,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryRed,
        secondary: lightRed,
        surface: white,
        background: grey,
        error: Colors.red,
        onPrimary: white,
        onSecondary: darkGrey,
        onSurface: darkGrey,
        onBackground: darkGrey,
        onError: white,
      ),
    );
  }
}
