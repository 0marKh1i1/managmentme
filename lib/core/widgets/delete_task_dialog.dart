import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteTaskDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const DeleteTaskDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('delete_task'.tr),
      content: Text('delete_task_confirmation'.tr),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('cancel'.tr),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Get.back();
            onConfirm();
          },
          child: Text('delete'.tr, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
