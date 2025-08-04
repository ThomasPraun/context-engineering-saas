import 'package:flutter/material.dart';

/// Centralized theme configuration for the entire app.
/// 
/// All theme-related settings are defined here to maintain
/// consistency and enable easy UI modifications from a single location.
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      
      // App bar theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        titleTextStyle: AppTextStyles.h3.copyWith(
          color: AppColors.textDark,
        ),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      
      // App bar theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textLight,
        titleTextStyle: AppTextStyles.h3.copyWith(
          color: AppColors.textLight,
        ),
      ),
    );
  }
}

// Placeholder classes - these would be in separate files
class AppColors {
  static const primary = Color(0xFF2196F3);
  static const textDark = Color(0xFF212121);
  static const textLight = Color(0xFFFFFFFF);
  static const textLightSecondary = Color(0xFFB0B0B0);
}

class AppTextStyles {
  static const h3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const body = TextStyle(fontSize: 16);
  static const button = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const caption = TextStyle(fontSize: 12);
}

class AppDimensions {
  static const paddingSmall = 8.0;
  static const paddingMedium = 16.0;
  static const paddingLarge = 24.0;
  static const radiusSmall = 8.0;
  static const radiusMedium = 12.0;
  static const radiusLarge = 16.0;
}