import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/modules/settings/settings_screen/controllers/settings_controller.dart';
import 'package:managementme/core/widgets/editable_profile_image.dart';

class SettingsHeader extends GetView<SettingsController> {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(24, 75, 24, 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: cs.surface,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            children: [
              const EditableProfileImage(size: 110, showCameraIcon: true),
              const SizedBox(height: 16),
              GetBuilder<SettingsController>(
                builder: (controller) => Text(
                  controller.currentUser?.name.isNotEmpty == true
                      ? controller.currentUser!.name
                      : 'unkown'.tr,
                  style: GoogleFonts.beVietnamPro(
                    color: cs.onSurface.withValues(alpha: 0.8),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              GetBuilder<SettingsController>(
                builder: (controller) => Text(
                  controller.currentUser?.email ?? '',
                  style: GoogleFonts.beVietnamPro(
                    color: cs.onSurface.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              GetBuilder<SettingsController>(
                builder: (controller) => Text(
                  controller.branchName,
                  style: GoogleFonts.beVietnamPro(
                    color: cs.onSurface.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
