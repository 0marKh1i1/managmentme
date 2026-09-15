import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/core/utils/contrast_color.dart';

class CheckInIndicator extends StatelessWidget {
  final double size;
  final bool isCheckedIn;

  const CheckInIndicator(this.isCheckedIn , {super.key, this.size = 0});

  @override
  Widget build(BuildContext context) {
    final bool isIn = isCheckedIn;
    Color bg = isIn ? AppThemes.checkedInColor : AppThemes.notCheckedInColor;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isIn ? "checked_in".tr : "not_checked_in".tr,
        style:TextStyle(fontSize: size == 0 ? null : size , color: ContrastColor.getContrastBlackWhite(bg)),
      ),
    );
  }
}
