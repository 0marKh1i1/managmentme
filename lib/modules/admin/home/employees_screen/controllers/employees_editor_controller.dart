import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/user_model.dart';

class EmployeesEditorController extends GetxController {
  bool _isLocked = true;
  bool get isLoacked => _isLocked;
  bool get isEnabled => !_isLocked;

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

    if (employee == null) {
      _isLocked = false;
    } else {
      _isLocked = true;
    }
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

  void setIsLoacked(bool b) {
    _isLocked = b;
    update();
  }

  bool toggleLock() {
    setIsLoacked(!_isLocked);
    return isLoacked;
  }
}
