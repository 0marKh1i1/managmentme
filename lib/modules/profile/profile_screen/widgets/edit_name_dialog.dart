import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/modules/profile/profile_screen/controllers/profile_controller.dart';

class EditNameDialog extends GetView<ProfileController> {
  const EditNameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('edit_name'.tr),
      content: TextField(
        controller: controller.nameController,
        decoration: InputDecoration(
          hintText: 'enter_your_name'.tr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        autofocus: true,
        textCapitalization: TextCapitalization.words,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('cancel'.tr),
        ),
        GetBuilder<ProfileController>(builder: (controller) => ElevatedButton(
              onPressed: controller.isUpdatingName
                  ? null
                  : controller.saveName,
              child: controller.isUpdatingName
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('save'.tr),
            )),
      ],
    );
  }
}
