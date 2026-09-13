import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/core/models/user_model.dart';

class CheckInIndicator extends StatelessWidget {
  
  final UserModel user;
  
  const CheckInIndicator(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: BoxDecoration(
        color: user.isCheckedIn
            ? AppThemes.checkedInColor
            : AppThemes.notCheckedInColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(user.isCheckedIn ? "checked_in".tr : "not_checked_in".tr),
    );
  }
}
