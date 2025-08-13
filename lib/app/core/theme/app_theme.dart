import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData _themeData(
    Brightness brightness,
    AppColors colors,
  ) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.text,
      secondary: colors.primary,
      onSecondary: colors.text,
      error: colors.error,
      onError: colors.text,
      surface: colors.surface,
      onSurface: colors.text,
      surfaceContainer: colors.surface,
      surfaceContainerHigh: colors.surfaceHigh,
    );

    final themeData = ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    );

    return themeData.copyWith(
      scaffoldBackgroundColor: colors.surface,
    );
  }

  static ThemeData get light => _themeData(Brightness.light, AppColors.light);

  static ThemeData get dark => _themeData(Brightness.dark, AppColors.dark);
}
