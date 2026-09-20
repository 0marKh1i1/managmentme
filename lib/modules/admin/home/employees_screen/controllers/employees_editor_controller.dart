import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/core/widgets/toast.dart';
import 'package:managementme/modules/admin/home/employees_screen/repo/employees_repo.dart';
import 'package:managementme/modules/admin/home/home_screen/controllers/home_controller.dart';
import 'package:managementme/modules/admin/home/home_screen/repo/home_repo.dart';

class EmployeesEditorController extends GetxController {
  bool _isLocked = true;
  bool get isLoacked => _isLocked;
  bool get isEnabled => !_isLocked;

  bool _isCheckIn = true;
  bool get isCheckIn => _isCheckIn;
  bool get isCheckOut => !_isCheckIn;

  bool _isEmployeeEnabled = true;
  bool get isEmployeeEnabled => _isEmployeeEnabled;

  bool isSaving = false;
  bool isNew = false;

  UserModel? employee;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  BranchModel? branch;
  BranchModel? selectedBranch;
  UserType selectedRole = UserType.employee;

  void initWith(UserModel? user) {
    employee = user;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      phoneController.text = user.phone;
      selectedRole = user.role;
      _isCheckIn = user.isCheckedIn;
      _isEmployeeEnabled = user.isEnabled;
      _fetchBranchName(user.branchId);
      _isLocked = true;
    } else {
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      _isCheckIn = false;
      _isEmployeeEnabled = true;
      _isLocked = false;
      isNew = true;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void saveChanges() async {
    if (!formKey.currentState!.validate()) {
      return; 
    }

    UserModel updatedEmployee;
    isSaving = true;
    update();

    try {
      if (employee == null) {
        await EmployeesRepo.createEmployeeByAdmin(
          email: emailController.text,
          phone: phoneController.text,
          pass: passwordController.text,
          username: nameController.text,
          role: selectedRole,
          branch: selectedBranch ,
          isCheckedIn: isCheckIn,
          isEnabled: _isEmployeeEnabled
        );
      } else {
        updatedEmployee = employee!.copyWith(
          email: emailController.text.isEmpty ? null : emailController.text,
          name: nameController.text,
          phone: phoneController.text,
          role: selectedRole,
          isCheckedIn: isCheckIn,
          branchId: selectedBranch != null ? selectedBranch!.id : '',
          isEnabled: _isEmployeeEnabled,
        );
        await EmployeesRepo.updateUser(updatedEmployee);
      }
      if (isClosed) return;
      Get.find<HomeController>().fetchEmployees();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
      toast('error'.tr, e.toString()); // 🔑 Context parameter removed
      isSaving = false;
      update();
    }
  }

  void setBranch(BranchModel? value) {
    selectedBranch = value;
  }

  Future<void> _fetchBranchName(String branchId) async {
    try {
      branch = await HomeRepo.getBranch(branchId);

      if (isClosed) return;
      if (branch != null) {
        selectedBranch = branch;
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
  
  void setIsEmployeeEnabled(bool b) {
    _isEmployeeEnabled = b;
    update();
  }

  bool toggleEmployeeEnabled() {
    setIsEmployeeEnabled(!_isEmployeeEnabled);
    return isEmployeeEnabled;
  }

  void setIsCheckIn(bool b) {
    _isCheckIn = b;
    update();
  }

  bool toggleIsCheckIn() {
    setIsCheckIn(!_isCheckIn);
    return isCheckIn;
  }

  void setRole(UserType role) {
    selectedRole = role;
    update();
  }
}
