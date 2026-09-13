import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/core/models/user_model.dart';

class CheckInIndicator extends StatelessWidget {
  
  final UserModel? user;
  
  const CheckInIndicator(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIn = user != null ? user!.isCheckedIn : false; 
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: BoxDecoration(
        color: isIn
            ? AppThemes.checkedInColor
            : AppThemes.notCheckedInColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(isIn ? "checked_in".tr : "not_checked_in".tr),
    );
  }
}
