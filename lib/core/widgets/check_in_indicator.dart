import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:managementme/core/constants/app_themes.dart';

class CheckInIndicator extends StatelessWidget {
  final double size;
  final bool isCheckedIn;

  const CheckInIndicator(this.isCheckedIn , {super.key, this.size = 0});

  @override
  Widget build(BuildContext context) {
    final bool isIn = isCheckedIn;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: BoxDecoration(
        color: isIn ? AppThemes.checkedInColor : AppThemes.notCheckedInColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isIn ? "checked_in".tr : "not_checked_in".tr,
        style: size == 0 ? null : TextStyle(fontSize: size),
      ),
    );
  }
}
