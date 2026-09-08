import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:managementme/modules/profile/profile_screen/controllers/profile_controller.dart';

class ImagePickerBottomSheet extends GetView<ProfileController> {
  const ImagePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'change_account_image'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _SheetOptionTile(
            icon: Icons.photo_library_rounded,
            label: 'gallery'.tr,
            onTap: () {
              Get.back();
              controller.pickImage(ImageSource.gallery);
            },
          ),
          const SizedBox(height: 12),
          _SheetOptionTile(
            icon: Icons.camera_alt_rounded,
            label: 'camera'.tr,
            onTap: () {
              Get.back();
              controller.pickImage(ImageSource.camera);
            },
          ),
          GetBuilder<ProfileController>(builder: (controller) {
            final photoUrl = controller.currentUser?.photoUrl ?? '';
            if (photoUrl.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _SheetOptionTile(
                icon: Icons.delete_outline_rounded,
                label: 'remove'.tr,
                isDestructive: true,
                onTap: () {
                  Get.back();
                  controller.removeImage();
                },
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SheetOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SheetOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isDestructive ? Colors.red : colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
