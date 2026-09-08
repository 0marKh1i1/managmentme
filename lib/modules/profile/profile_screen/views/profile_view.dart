import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/core/constants/app_colors.dart';
import 'package:managementme/modules/profile/profile_screen/controllers/profile_controller.dart';
import 'package:managementme/modules/profile/profile_screen/widgets/profile_header.dart';
import 'package:managementme/modules/profile/profile_screen/widgets/profile_stat_card.dart';
import 'package:managementme/modules/profile/profile_screen/widgets/profile_tile.dart';
import 'package:managementme/modules/profile/profile_screen/widgets/theme_selector_tile.dart';
import 'package:managementme/modules/profile/profile_screen/widgets/language_selector_tile.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const ProfileHeader(),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: GetBuilder<ProfileController>(builder: (controller) => ProfileStatCard(
                    totalTasks: controller.totalTasks,
                  )),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'appearance'.tr.toUpperCase(),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: 0.45),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const ThemeSelectorTile(),
                  const SizedBox(height: 12),
                  const LanguageSelectorTile(),
                  const SizedBox(height: 28),
                  Text(
                    'account'.tr.toUpperCase(),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: 0.45),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfileTile(
                    icon: Icons.drive_file_rename_outline_rounded,
                    label: 'edit_name'.tr,
                    subtitle: 'update_display_name'.tr,
                    onTap: controller.showEditNameDialog,
                    accentColor: customColors.statPendingColor,
                  ),
                  const SizedBox(height: 10),
                  ProfileTile(
                    icon: Icons.add_a_photo_rounded,
                    label: 'change_account_image'.tr,
                    subtitle: 'update_profile_photo'.tr,
                    onTap: controller.showImagePickerSheet,
                    accentColor: customColors.statCompletedColor,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'session'.tr.toUpperCase(),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: 0.45),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfileTile(
                    icon: Icons.logout_rounded,
                    label: 'logout'.tr,
                    subtitle: 'sign_out_of_account'.tr,
                    onTap: controller.showLogoutDialog,
                    isDestructive: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 125),
          ],
        ),
      ),
    );
  }
}
