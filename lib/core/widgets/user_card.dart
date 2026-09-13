import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/core/widgets/check_in_indicator.dart';
import 'package:managementme/modules/admin/home/employees_screen/controllers/employees_controller.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppThemes.cardShadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                ? NetworkImage(user.photoUrl!)
                : AssetImage('assets/images/profile.png'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.isNotEmpty ? user.name : 'Unknown User',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                const SizedBox(height: 4),
                Text(
                  user.phone.isNotEmpty ? user.phone : 'No phone provided',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  user.email.isNotEmpty ? user.email : 'No email provided',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              CheckInIndicator(user),
              SizedBox(height: 10,),
              GetBuilder<EmployeesController>(
                builder: (controller) {
                  var branchName = controller.getBranch(user.branchId) != null ? controller.getBranch(user.branchId)!.name : "unkown".tr;
                  return Text(branchName + "branch".tr);
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}
