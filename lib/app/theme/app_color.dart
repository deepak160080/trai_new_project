
import 'package:flutter/material.dart';
class AppColors {
  // Base Seed Colors (Material 3 will generate variants from this)
  static const Color seedPrimary = Color(0xFF80E27E);
  static const Color seedSecondary = Color(0xFF09141B);
  static const Color seedError = Color(0xFFB71C1C);

  // Generates a light color scheme based on the seed colors
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: seedPrimary,
    brightness: Brightness.light,
    error: seedError,
  );

  // Generates a dark color scheme based on the seed colors
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: seedPrimary,
    brightness: Brightness.dark,
    error: seedError,
  );
}