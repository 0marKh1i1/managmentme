import 'package:managementme/modules/auth/login_screen/repo/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/widgets/toast.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  var hidePass = true.obs;
  var isLoading = false.obs;

  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  void onClose() {
    email.dispose();
    pass.dispose();
    super.onClose();
  }

  Future<void> onLoginButton() async {
    if (isLoading.value) {
      return;
    } else {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        try {
          await LoginRepo.login(email: email.text, pass: pass.text);
          Get.offAllNamed("/root");
        } on Exception catch (e) {
          toast('Error', e.toString().replaceAll("Exception: ", ""));
        } finally {
          isLoading.value = false;
        }
      }
    }
  }

  void togglepass() {
    hidePass.value = !hidePass.value;
  }
}
