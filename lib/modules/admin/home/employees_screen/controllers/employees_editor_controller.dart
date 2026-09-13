import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/user_model.dart';

class EmployeesEditorController extends GetxController {
  UserModel? employee;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController branchController;

  @override
  void onInit() {
    super.onInit();
    employee = Get.arguments as UserModel?;

    nameController = TextEditingController(text: employee?.name ?? '');
    emailController = TextEditingController(text: employee?.email ?? '');
    phoneController = TextEditingController(text: employee?.phone ?? '');
    branchController = TextEditingController(text: '');
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    branchController.dispose();
    super.onClose();
  }

  void saveChanges() {
    // todo
    Get.back();
  }
}
