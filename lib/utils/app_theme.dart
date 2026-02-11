import 'package:flutter/material.dart';
import 'app_design_system.dart';

/// Global theme and color palette. Use with Theme.of(context) and AppTheme.*.
/// Design rules: light tinted background, no plain white screens, no sharp corners,
/// card-based surfaces, all widgets styled via theme or design system.
class AppTheme {
  AppTheme._();

  // ─── Colors ─────────────────────────────────────────────────────────────
  static const Color primaryColor = Color(0xFF00C853);
  static const Color primaryDark = Color(0xFF00A844);
  static const Color primaryLight = Color(0xFF4DD865);
  static const Color secondaryColor = Color(0xFFFF5722);
  static const Color accentColor = Color(0xFFFFD600);

  /// Light background with subtle tint (no plain white screens).
  static const Color scaffoldBackground = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  /// Secondary surface for cards on tinted background.
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFE8F5E9);
  static const Color backgroundColorAlt = Color(0xFFFFF3E0);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  static const Color categoryRed = Color(0xFFFF1744);
  static const Color categoryOrange = Color(0xFFFF6F00);
  static const Color categoryYellow = Color(0xFFFFD600);
  static const Color categoryGreen = Color(0xFF00C853);
  static const Color categoryBlue = Color(0xFF2979FF);
  static const Color categoryPurple = Color(0xFFAA00FF);
  static const Color categoryPink = Color(0xFFFF4081);
  static const Color categoryCyan = Color(0xFF00E5FF);

  static const List<Color> primaryGradient = [Color(0xFF00C853), Color(0xFF00A844)];
  static const List<Color> sunsetGradient = [Color(0xFFFF6B35), Color(0xFFF7931E)];
  static const List<Color> oceanGradient = [Color(0xFF2979FF), Color(0xFF00E5FF)];
  static const List<Color> purpleGradient = [Color(0xFFAA00FF), Color(0xFFFF4081)];

  /// Shadow color for cards and elevated surfaces (subtle).
  static Color get shadowColor => Colors.black.withValues(alpha: 0.08);
  static Color get shadowColorStrong => Colors.black.withValues(alpha: 0.12);

  // ─── ThemeData ──────────────────────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'PingFang SC',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        error: categoryRed,
        onPrimary: textOnPrimary,
        onSecondary: textOnPrimary,
        onSurface: textPrimary,
        onError: textOnPrimary,
        onSurfaceVariant: textSecondary,
      ),
      scaffoldBackgroundColor: scaffoldBackground,
      canvasColor: scaffoldBackground,

      // AppBar: surface color, subtle elevation, no sharp look
      appBarTheme: AppBarTheme(
        elevation: AppDesignSystem.elevationLow,
        scrolledUnderElevation: AppDesignSystem.elevationCard,
        centerTitle: true,
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: textPrimary, size: 24),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),

      // Cards: rounded corners (14–24), elevation, no flat surfaces
      cardTheme: CardThemeData(
        elevation: AppDesignSystem.elevationCard,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusLg,
        ),
        color: cardColor,
        margin: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spacingLg,
          vertical: AppDesignSystem.spacingSm,
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Inputs: rounded, filled, consistent padding
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spacingXl,
          vertical: AppDesignSystem.spacingLg,
        ),
        border: OutlineInputBorder(borderRadius: AppDesignSystem.borderRadiusMd),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
          borderSide: const BorderSide(color: primaryColor, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
          borderSide: const BorderSide(color: categoryRed, width: 1.5),
        ),
      ),

      // Elevated button: rounded, elevation, no flat
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimary,
          elevation: AppDesignSystem.elevationRaised,
          shadowColor: primaryColor.withValues(alpha: 0.35),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spacingXl * 1.6,
            vertical: AppDesignSystem.spacingLg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDesignSystem.borderRadiusMd,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: AppDesignSystem.paddingHorizontal,
          shape: RoundedRectangleBorder(
            borderRadius: AppDesignSystem.borderRadiusMd,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spacingXl,
            vertical: AppDesignSystem.spacingLg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDesignSystem.borderRadiusMd,
          ),
        ),
      ),

      // Chips: pill shape, rounded (14–24)
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        selectedColor: primaryColor,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spacingLg,
          vertical: AppDesignSystem.spacingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusXl,
        ),
        elevation: AppDesignSystem.elevationLow,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      primaryIconTheme: const IconThemeData(
        color: primaryColor,
        size: 24,
      ),

      // Bottom nav: elevation, surface color
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: AppDesignSystem.elevationNavBar,
        selectedItemColor: primaryColor,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
      ),

      // Dialog: rounded corners, no sharp
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        elevation: AppDesignSystem.elevationModal,
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusXl,
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: textSecondary,
        ),
      ),

      // Bottom sheet: rounded top corners (14–24)
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        elevation: AppDesignSystem.elevationModal,
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusTopSheet,
        ),
        showDragHandle: true,
      ),

      // Snackbar: rounded
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: textPrimary,
        contentTextStyle: const TextStyle(color: textOnDark),
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
        ),
        elevation: AppDesignSystem.elevationRaised,
      ),

      // List tile: consistent padding
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spacingLg,
          vertical: AppDesignSystem.spacingXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
        space: AppDesignSystem.spacingLg,
      ),

      // Tab bar
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimary,
        elevation: AppDesignSystem.elevationRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radiusXl),
        ),
      ),

      // Typography
      textTheme: _textTheme,
    );
  }

  static const TextTheme _textTheme = TextTheme(
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
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textTertiary,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textSecondary,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: textTertiary,
      letterSpacing: 0.5,
    ),
  );
}
