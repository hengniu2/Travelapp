import 'package:flutter/material.dart';

class AppTheme {
  // Ultra vibrant Chinese-style colors
  static const Color primaryColor = Color(0xFF00C853); // Bright emerald green
  static const Color primaryDark = Color(0xFF00A844);
  static const Color primaryLight = Color(0xFF4DD865);
  static const Color secondaryColor = Color(0xFFFF5722); // Deep orange
  static const Color accentColor = Color(0xFFFFD600); // Bright yellow
  static const Color backgroundColor = Color(0xFFE8F5E9); // Light green tint
  static const Color backgroundColorAlt = Color(0xFFFFF3E0); // Light orange tint
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF000000); // Pure black for maximum contrast
  static const Color textSecondary = Color(0xFF424242); // Dark gray for contrast
  static const Color textOnDark = Colors.white; // White text for dark backgrounds
  
  // Rich category colors for icons
  static const Color categoryRed = Color(0xFFFF1744);
  static const Color categoryOrange = Color(0xFFFF6F00);
  static const Color categoryYellow = Color(0xFFFFD600);
  static const Color categoryGreen = Color(0xFF00C853);
  static const Color categoryBlue = Color(0xFF2979FF);
  static const Color categoryPurple = Color(0xFFAA00FF);
  static const Color categoryPink = Color(0xFFFF4081);
  static const Color categoryCyan = Color(0xFF00E5FF);
  
  // Gradient colors
  static const List<Color> primaryGradient = [Color(0xFF00C853), Color(0xFF00A844)];
  static const List<Color> sunsetGradient = [Color(0xFFFF6B35), Color(0xFFF7931E)];
  static const List<Color> oceanGradient = [Color(0xFF2979FF), Color(0xFF00E5FF)];
  static const List<Color> purpleGradient = [Color(0xFFAA00FF), Color(0xFFFF4081)];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: textPrimary,
        iconTheme: const IconThemeData(color: textPrimary, size: 24),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: cardColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.4),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        selectedColor: primaryColor,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 2,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
    );
  }
}

