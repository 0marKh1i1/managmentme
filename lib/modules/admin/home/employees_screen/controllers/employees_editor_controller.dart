import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/modules/admin/home/employees_screen/repo/employees_repo.dart';
import 'package:managementme/modules/admin/home/home_screen/repo/home_repo.dart';

class EmployeesEditorController extends GetxController {
  bool _isLocked = true;
  bool get isLoacked => _isLocked;
  bool get isEnabled => !_isLocked;

  bool isSaving = false;
  bool isCheckedIn = false;

  UserModel? employee;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController branchController;

  BranchModel? branch;
  UserType selectedRole = UserType.employee;

  @override
  void onInit() {
    super.onInit();
    employee = Get.arguments as UserModel?;

    nameController = TextEditingController(text: employee?.name ?? '');
    emailController = TextEditingController(text: employee?.email ?? '');
    phoneController = TextEditingController(text: employee?.phone ?? '');
    branchController = TextEditingController(text: '');
  }

  void initWith(UserModel? user) {
    employee = user;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      phoneController.text = user.phone;
      branchController.text = "unkown".tr;
      selectedRole = user.role;
      _fetchBranchName(user.branchId);
      _isLocked = true;
    } else {
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      branchController.clear();
      _isLocked = false;
    }
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    branchController.dispose();
    super.onClose();
  }

  void saveChanges() async {
    if (employee == null) {
      Get.back();
      return;
    }

    UserModel updatedEmployee = employee!.copyWith(
      name: nameController.text,
      phone: phoneController.text,
      role: selectedRole,
      isCheckedIn: isCheckedIn
    );

    isSaving = true;
    update();

    await EmployeesRepo.updateUser(updatedEmployee);

    if (isClosed) return;

    Get.back();
  }

  Future<void> _fetchBranchName(String branchId) async {
    try {
      branch = await HomeRepo.getBranch(branchId);

      if (isClosed) return;
      if (branch != null) {
        branchController.text = branch!.name;
        update();
      }
    } catch (e) {
      debugPrint("branch check Error: $e");
    }
  }

  void setIsLoacked(bool b) {
    _isLocked = b;
    update();
  }

  bool toggleLock() {
    setIsLoacked(!_isLocked);
    return isLoacked;
  }

  void setRole(UserType role) {
    selectedRole = role;
    update();
  }
}
