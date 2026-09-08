import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/widgets/toast.dart';
import 'package:managementme/modules/auth/forgot_password_screen/repo/forgot_password_repo.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final ForgotPasswordRepo repo = ForgotPasswordRepo();
  
  bool isLoading = false;

  Future<void> submit() async {
    if (isLoading) return;
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading = true;
    update();

    try {
      await repo.sendPasswordResetEmail(email.text.trim());
      toast('password_reset_email_sent'.tr);
      Get.back();
    } catch (e) {
      toast("${'error'.tr}: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }
}