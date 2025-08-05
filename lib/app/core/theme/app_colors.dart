import 'package:flutter/material.dart';

class AppColors {
  final Color text;
  final Color primary;
  final Color surface;
  final Color surfaceHigh;
  final Color error;

  const AppColors({
    required this.text,
    required this.primary,
    required this.surface,
    required this.surfaceHigh,
    required this.error,
  });

  static AppColors light = AppColors(
    text: Colors.black.withValues(alpha: 0.8),
    primary: Colors.black,
    surface: const Color(0xFFF0F0F0),
    surfaceHigh: const Color(0xFFFFFFFF),
    error: Colors.redAccent,
  );
}
