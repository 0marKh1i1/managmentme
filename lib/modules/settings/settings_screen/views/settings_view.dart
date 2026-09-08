import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/modules/settings/settings_screen/controllers/settings_controller.dart';
import 'package:managementme/modules/settings/settings_screen/widgets/settings_header.dart';
import 'package:managementme/modules/settings/settings_screen/widgets/settings_tile.dart';
import 'package:managementme/modules/settings/settings_screen/widgets/theme_selector_tile.dart';
import 'package:managementme/modules/settings/settings_screen/widgets/language_selector_tile.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SettingsHeader(),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
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
                    SettingsTile(
                      icon: Icons.drive_file_rename_outline_rounded,
                      label: 'edit_name'.tr,
                      subtitle: 'update_display_name'.tr,
                      onTap: controller.showEditNameDialog,
                      accentColor: cs.primary.withValues(alpha: 0.8),
                    ),
                    const SizedBox(height: 10),
                    SettingsTile(
                      icon: Icons.add_a_photo_rounded,
                      label: 'change_account_image'.tr,
                      subtitle: 'update_profile_photo'.tr,
                      onTap: controller.showImagePickerSheet,
                      accentColor: cs.primary.withValues(alpha: 0.8),
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
                    SettingsTile(
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
      ),
    );
  }
}
