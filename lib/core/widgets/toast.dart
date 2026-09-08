import 'package:flutter/material.dart';
import 'package:get/get.dart';

void toast(String title, String msg) {
  Get.snackbar(
    title,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
  );
}
