import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/core/constants/app_colors.dart';
import 'package:managementme/modules/profile/profile_screen/controllers/profile_controller.dart';

class ProfileHeader extends GetView<ProfileController> {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(24, 75, 24, 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: customColors.profileCardColor!,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            children: [
              GetBuilder<ProfileController>(
                builder: (controller) {
                  final photoUrl = controller.currentUser?.photoUrl ?? '';
                  final isUploading = controller.isUploadingImage;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.onPrimary, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: isUploading
                              ? Container(
                                  color: cs.onPrimary.withValues(alpha: 0.2),
                                  child: CircularProgressIndicator(
                                    color: cs.onPrimary,
                                  ),
                                )
                              : photoUrl.isNotEmpty
                              ? Image.network(
                                  photoUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, e, st) => Image.asset(
                                    'assets/images/profile.png',
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/profile.png',
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.showImagePickerSheet,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: cs.surface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 17,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              GetBuilder<ProfileController>(
                builder: (controller) => Text(
                  controller.currentUser?.name.isNotEmpty == true
                      ? controller.currentUser!.name
                      : '—',
                  style: GoogleFonts.beVietnamPro(
                    color: customColors.profileTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              GetBuilder<ProfileController>(
                builder: (controller) => Text(
                  controller.currentUser?.email ?? '',
                  style: GoogleFonts.beVietnamPro(
                    color: customColors.profileTextColor!.withValues(
                      alpha: 0.8,
                    ),
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
