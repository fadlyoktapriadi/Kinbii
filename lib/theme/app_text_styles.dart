import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kinbii/theme/app_theme.dart';

class AppTextStyles {

  static final AppTextStyles _instance = AppTextStyles._internal();

  factory AppTextStyles() => _instance;

  AppTextStyles._internal();

  TextStyle iconAppText = GoogleFonts.calSans(
    fontSize: (26.sp).clamp(26.0, 36.0).toDouble(),
    color: AppTheme.appColors.primary,
    fontWeight: FontWeight.bold,
  );

  TextStyle appName = GoogleFonts.sourGummy(
    fontSize: (26.sp).clamp(26.0, 36.0).toDouble(),
    color: AppTheme.appColors.primary,
    fontWeight: FontWeight.bold,
  );

  TextStyle header1 = GoogleFonts.poppins(
    fontSize: (24.sp).clamp(24.0, 34.0).toDouble(),
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  TextStyle header2 = GoogleFonts.poppins(
    fontSize: (20.sp).clamp(20.0, 30.0).toDouble(),
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  TextStyle header3 = GoogleFonts.poppins(
    fontSize: (16.sp).clamp(16.0, 24.0).toDouble(),
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: (16.sp).clamp(16.0, 24.0).toDouble(),
    fontWeight: FontWeight.w500,
  );

  TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: (14.sp).clamp(14.0, 20.0).toDouble(),
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: (12.sp).clamp(12.0, 18.0).toDouble(),
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  TextStyle bodyXSmall = GoogleFonts.poppins(
    fontSize: (10.sp).clamp(10.0, 16.0).toDouble(),
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

}