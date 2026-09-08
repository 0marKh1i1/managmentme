import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color? profileCardColor;
  final Color? profileTextColor;
  final Color? statTotalColor;
  final Color? statHighPriorityColor;
  final Color? statCompletedColor;
  final Color? statPendingColor;
  final Color? statTextColor;
  final Color? modalDividerColor;
  final Color? fieldLabelColor;

  const AppColors({
    this.profileCardColor,
    this.profileTextColor,
    this.statTotalColor,
    this.statHighPriorityColor,
    this.statCompletedColor,
    this.statPendingColor,
    this.statTextColor,
    this.modalDividerColor,
    this.fieldLabelColor,
  });

  @override
  AppColors copyWith({
    Color? profileCardColor,
    Color? profileTextColor,
    Color? statTotalColor,
    Color? statHighPriorityColor,
    Color? statCompletedColor,
    Color? statPendingColor,
    Color? statTextColor,
    Color? modalDividerColor,
    Color? fieldLabelColor,
  }) {
    return AppColors(
      profileCardColor: profileCardColor ?? this.profileCardColor,
      profileTextColor: profileTextColor ?? this.profileTextColor,
      statTotalColor: statTotalColor ?? this.statTotalColor,
      statHighPriorityColor: statHighPriorityColor ?? this.statHighPriorityColor,
      statCompletedColor: statCompletedColor ?? this.statCompletedColor,
      statPendingColor: statPendingColor ?? this.statPendingColor,
      statTextColor: statTextColor ?? this.statTextColor,
      modalDividerColor: modalDividerColor ?? this.modalDividerColor,
      fieldLabelColor: fieldLabelColor ?? this.fieldLabelColor,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      profileCardColor: Color.lerp(profileCardColor, other.profileCardColor, t),
      profileTextColor: Color.lerp(profileTextColor, other.profileTextColor, t),
      statTotalColor: Color.lerp(statTotalColor, other.statTotalColor, t),
      statHighPriorityColor: Color.lerp(statHighPriorityColor, other.statHighPriorityColor, t),
      statCompletedColor: Color.lerp(statCompletedColor, other.statCompletedColor, t),
      statPendingColor: Color.lerp(statPendingColor, other.statPendingColor, t),
      statTextColor: Color.lerp(statTextColor, other.statTextColor, t),
      modalDividerColor: Color.lerp(modalDividerColor, other.modalDividerColor, t),
      fieldLabelColor: Color.lerp(fieldLabelColor, other.fieldLabelColor, t),
    );
  }
}
