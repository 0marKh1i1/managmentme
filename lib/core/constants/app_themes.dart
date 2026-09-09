import 'package:flutter/material.dart';

class AppThemes {
  static const Color primaryColor = Color(0xFF071333);
  static const Color darkPrimaryColor = Color.fromARGB(255, 24, 66, 179);

  static const Color secondaryColor = Color(0xFF0721A9);
  static const Color darkSecondaryColor = Color.fromARGB(255, 9, 43, 212);

  static const Color lightScaffoldBg = Color(0xFFFAFAFA);
  static const Color darkScaffoldBg = Color.fromARGB(255, 20, 20, 20);

  static const Color glassColor = Color(0xFF90A4AE);
  static const Color glassBorderColor = Colors.white;

  static const Color trackerActiveColor = Color(0xFF1976D2);
  static const Color trackerInactiveColor = Color(0xFF64B5F6);
  static const Color trackerLineInactiveColor = Color(0xFF90CAF9);
  static const Color fromToTextColor = Color(0xFF64B5F6);
  static const Color cardShadowColor = Color(0x0D000000);

  static const Color homeHeaderColor = Color(0xFF000000);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      sizeConstraints: BoxConstraints.tightFor(width: 70.0, height: 70.0),
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightScaffoldBg,
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      onSurface: Colors.black,
      surfaceDim: const Color(0xFF9E9E9E),
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      error: const Color(0xFFB00020),
      onError: Colors.white,
      outline: const Color(0xFFBDBDBD),
      outlineVariant: const Color(0xFF1E88E5),
      surfaceContainerHighest: lightScaffoldBg,
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      sizeConstraints: BoxConstraints.tightFor(width: 70.0, height: 70.0),
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkScaffoldBg,
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFEEEEEE),
      surfaceDim: Color(0xFF2C2C2C),
      primary: darkPrimaryColor,
      onPrimary: Colors.white,
      secondary: darkSecondaryColor,
      onSecondary: Colors.white,
      error: Color(0xFFCF6679),
      onError: Colors.black,
      outline: Color(0xFF5A5A5A),
      outlineVariant: Color(0xFF1E88E5),
      surfaceContainerHighest: Colors.black87,
    ),
  );
}
