import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/modules/settings/settings_screen/controllers/settings_controller.dart';

class LogoutDialog extends GetView<SettingsController> {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('logout'.tr),
      content: Text('logout_confirmation'.tr),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: controller.logout,
          child: Text('logout'.tr, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
