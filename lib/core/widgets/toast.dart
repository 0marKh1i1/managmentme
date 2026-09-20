import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/utils/contrast_color.dart';

void toast(String title, String msg, {Color? backgroundColor}) {
  Color bg =
      backgroundColor ??
      (Get.context != null
          ? Theme.of(Get.context!).colorScheme.onSurface
          : Colors.black);

  bg = bg.withAlpha(200);

  Get.snackbar(
    title,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
    backgroundColor: bg,
    colorText: ContrastColor.getContrastBlackWhite(bg),
  );
}
