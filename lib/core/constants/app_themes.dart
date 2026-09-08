import 'package:flutter/material.dart';
import 'package:managementme/core/constants/app_colors.dart';


class AppThemes {
  static const Color primaryColor = Color(0xFF3E4ADE);
  static const Color darkPrimaryColor = Color(0xFF6B75FF);

  static const Color lightScaffoldBg = Color(0xFFFAFAFA);
  static const Color darkScaffoldBg = Color(0xFF181818);

  static const Color profileCardBg = Color(0xFFF8E9C8);
  static const Color profileTextDark = Color(0xFF181818);

  static const Color statTotalBg = Color(0xFFFFFFFF);
  static const Color statHighPriorityBg = Color(0xFFFAADAD);
  static const Color statCompletedBg = Color(0xFF8CD9FF);
  static const Color statPendingBg = Color(0xFFFFCA8E);
  static const Color statTextDark = Color(0xFF000000);

  static const Color modalDivider = Color(0xFFEEEEEE);
  static const Color modalDividerDark = Color(0xFF3A3A3A);

  static const Color fieldLabel = Color(0xFF3A3A3A);
  static const Color fieldLabelDark = Color(0xFFCCCCCC);

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
      secondary: const Color(0xFF03DAC6),
      onSecondary: Colors.black,
      error: const Color(0xFFB00020),
      onError: Colors.white,
      outline: const Color(0xFFBDBDBD),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(
        profileCardColor: profileCardBg,
        profileTextColor: profileTextDark,
        statTotalColor: statTotalBg,
        statHighPriorityColor: statHighPriorityBg,
        statCompletedColor: statCompletedBg,
        statPendingColor: statPendingBg,
        statTextColor: statTextDark,
        modalDividerColor: modalDivider,
        fieldLabelColor: fieldLabel,
      ),
    ],
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      sizeConstraints: BoxConstraints.tightFor(width: 70.0, height: 70.0),
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkScaffoldBg,
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFEEEEEE),
      surfaceDim: Color(0xFF2C2C2C),
      primary: darkPrimaryColor,
      onPrimary: Colors.white,
      secondary: Color(0xFF03DAC6),
      onSecondary: Colors.black,
      error: Color(0xFFCF6679),
      onError: Colors.black,
      outline: Color(0xFF5A5A5A),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(
        profileCardColor: profileCardBg,
        profileTextColor: profileTextDark,
        statTotalColor: statTotalBg,
        statHighPriorityColor: statHighPriorityBg,
        statCompletedColor: statCompletedBg,
        statPendingColor: statPendingBg,
        statTextColor: statTextDark,
        modalDividerColor: modalDividerDark,
        fieldLabelColor: fieldLabelDark,
      ),
    ],
  );
}
