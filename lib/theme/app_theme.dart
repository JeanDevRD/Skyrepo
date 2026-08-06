import 'package:flutter/material.dart';

class AppTheme {
  static const _diaPrimario = Color(0xFF3D6EA5);
  static const _nochePrimario = Color(0xFF7C8FE0);
  static const _nocheFondo = Color(0xFF11142B);
  static const _acentoLuna = Color(0xFFE8D9A0);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _diaFondo,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _diaPrimario,
      brightness: Brightness.light,
    ).copyWith(secondary: _acentoLuna),
    appBarTheme: const AppBarTheme(
      backgroundColor: _diaPrimario,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _diaPrimario,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _nocheFondo,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _nochePrimario,
      brightness: Brightness.dark,
    ).copyWith(secondary: _acentoLuna),
    appBarTheme: const AppBarTheme(
      backgroundColor: _nocheFondo,
      foregroundColor: _acentoLuna,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1B1F3B),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _acentoLuna,
      foregroundColor: _nocheFondo,
    ),
  );

  static IconData iconoCategoria(String categoria) {
    switch (categoria) {
      case 'Astronomía':
        return Icons.nightlight_round;
      case 'Fenómeno atmosférico':
        return Icons.cloud_outlined;
      case 'Aves':
        return Icons.air_outlined;
      case 'Aeronave/Objeto artificial':
        return Icons.satellite_alt_outlined;
      default:
        return Icons.visibility_outlined;
    }
  }
}
