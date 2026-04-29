import 'package:flutter/material.dart';

class AppColors {

  static final AppColors _instance = AppColors._internal();

  factory AppColors() => _instance;

  AppColors._internal();

  Color primary = const Color(0xFF00bfff);
  Color secondary = const Color(0xffff6675);
  Color success = const Color(0xFF2E7D32);
  Color info = const Color(0xFF1976D2);
  Color warning = const Color(0xFFF57C00);
  Color danger = const Color(0xFFBA1A1A);
  Color disabled = const Color(0xFFDCDEE7);
  Color white = const Color(0xFFFFFFFF);
  Color black = const Color(0xFF151316);
  Color grey = const Color(0xFF79747E);
  Color softGrey = const Color(0xffCAC4D0);
}