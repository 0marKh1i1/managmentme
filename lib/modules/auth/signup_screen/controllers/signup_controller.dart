import 'package:managementme/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/modules/auth/signup_screen/repo/signup_repo.dart';
import 'package:managementme/core/widgets/toast.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  var hidePass = true.obs;
  var hideConfirmPass = true.obs;
  var isLoading = false.obs;
  var selectedRole = UserType.customer.obs;
  String? passwordstr;

  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  @override
  void onClose() {
    username.dispose();
    email.dispose();
    phone.dispose();
    pass.dispose();
    confirmPass.dispose();
    super.onClose();
  }

  Future<void> onSignupButton() async {
    if (isLoading.value) {
      return;
    } else {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        try {
          await SignupRepo.createUser(
            email: email.text,
            phone: phone.text,
            pass: pass.text,
            username: username.text,
            role: selectedRole.value,
          );
          Get.offAllNamed("/root");
        } on Exception catch (e) {
          toast('Error', e.toString().replaceAll("Exception: ", ""));
        } finally {
          isLoading.value = false;
        }
      }
    }
  }

  void togglePass() {
    hidePass.value = !hidePass.value;
    hideConfirmPass.value = hidePass.value;
  }

  void setRole(UserType role) {
    selectedRole.value = role;
  }

  void updatePasswordStr(String value) {
    passwordstr = value;
  }
}
