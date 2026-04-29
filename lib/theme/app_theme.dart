
import 'package:flutter/material.dart';
import 'package:kinbii/theme/app_colors.dart';
import 'package:kinbii/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData theme = lightTheme;

  static AppColors appColors = AppColors();

  static AppTextStyles appTextStyles = AppTextStyles();

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppTheme.appColors.primary,
      hintColor: AppTheme.appColors.primary,
      scaffoldBackgroundColor: AppTheme.appColors.white,
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: AppTheme.appColors.primary),
          surfaceTintColor: Colors.transparent,
          shadowColor: AppTheme.appColors.softGrey.withValues(alpha: 0.2),
          elevation: 3
      ),
      colorScheme: ColorScheme.light(
        primary: AppTheme.appColors.primary,
        secondary: AppTheme.appColors.secondary,
        error: AppTheme.appColors.danger,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppTheme.appColors.primary,
      hintColor: AppTheme.appColors.primary,
      scaffoldBackgroundColor: AppTheme.appColors.white,
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: AppTheme.appColors.primary),
          surfaceTintColor: Colors.transparent,
          shadowColor: AppTheme.appColors.softGrey.withValues(alpha: 0.2),
          elevation: 3
      ),
      colorScheme: ColorScheme.light(
        primary: AppTheme.appColors.primary,
        secondary: AppTheme.appColors.secondary,
        error: AppTheme.appColors.danger,
      ),
    );
  }
}