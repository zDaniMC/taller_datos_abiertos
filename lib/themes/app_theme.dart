import 'package:flutter/material.dart';

/// Tema global inspirado en los colores de la bandera de Colombia.
class AppTheme {
  AppTheme._();

  static const Color blue = Color(0xFF003893);
  static const Color yellow = Color(0xFFFCD116);
  static const Color red = Color(0xFFCE1126);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: blue,
      secondary: yellow,
      tertiary: red,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
