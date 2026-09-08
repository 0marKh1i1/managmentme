import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/modules/settings/settings_screen/controllers/settings_controller.dart';

class EditableProfileImage extends StatelessWidget {
  final double size;
  final bool showCameraIcon;
  final VoidCallback? onTap;

  const EditableProfileImage({
    super.key,
    this.size = 110,
    this.showCameraIcon = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GetBuilder<SettingsController>(
      builder: (controller) {
        final photoUrl = controller.currentUser?.photoUrl ?? '';
        final isUploading = controller.isUploadingImage;

        return GestureDetector(
          onTap:
              onTap ??
              () {
                if (!showCameraIcon) {
                  controller.showImagePickerSheet();
                }
              },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: cs.onPrimary,
                    width: size > 50 ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: size > 50 ? 20 : 8,
                      offset: Offset(0, size > 50 ? 8 : 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: isUploading
                      ? Container(
                          color: cs.onPrimary.withValues(alpha: 0.2),
                          child: CircularProgressIndicator(color: cs.onPrimary),
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
              if (showCameraIcon)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: controller.showImagePickerSheet,
                    child: Container(
                      width: size * 0.3,
                      height: size * 0.3,
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
                        size: size * 0.15,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
