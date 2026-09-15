import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const Color primaryColor = Color(0xFFBDD6D8);
  static const Color darkPrimaryColor = Color(0xFF799C9E);

  static const Color secondaryColor = Color(0xFF0721A9);
  static const Color darkSecondaryColor = Color.fromARGB(255, 9, 43, 212);

  static const Color lightScaffoldBg = Color(0xFFF1F1F1);
  static const Color darkScaffoldBg = Color(0xFF2B2B2B);

  static const Color glassColor = Color(0xFF90A4AE);
  static const Color glassBorderColor = Colors.white;

  static const Color cardShadowColor = Color(0x0D000000);

  static const Color homeHeaderColor = Color(0xFF000000);
  static const Color homeHeaderTextColor = Color(0xFFFFFFFF);

  static const Color checkedInColor = Color(0xFF42BA46);
  static const Color notCheckedInColor = Color(0xFFBA4242);


  static final ThemeData lightTheme = ThemeData.light().copyWith(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      sizeConstraints: BoxConstraints.tightFor(width: 70.0, height: 70.0),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    primaryTextTheme: GoogleFonts.interTextTheme(
      ThemeData.light().primaryTextTheme,
    ),

    brightness: Brightness.light,
    scaffoldBackgroundColor: lightScaffoldBg,
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      onSurface: Colors.black,
      surfaceDim: const Color.fromARGB(255, 241, 241, 241),
      primary: primaryColor,
      onPrimary: Colors.black,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      error: const Color(0xFFB00020),
      onError: Colors.white,
      outline: const Color(0xFFBDBDBD),
      outlineVariant: const Color(0xFF1E88E5),
      surfaceContainerHighest: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      sizeConstraints: BoxConstraints.tightFor(width: 70.0, height: 70.0),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    primaryTextTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().primaryTextTheme,
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
