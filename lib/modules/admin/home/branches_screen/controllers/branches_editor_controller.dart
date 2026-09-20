import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/branch_model.dart';

class BranchesEditorController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLocked = true;
  bool get isLoacked => _isLocked;
  bool get isEnabled => !_isLocked;

  bool isNew = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastCheckInController = TextEditingController();
  final TextEditingController fenceRadiusController = TextEditingController();

  void initWith(BranchModel? branch) {
    if (branch != null) {
      nameController.text = branch.name;
      lastCheckInController.text = branch.lastCheckInTime?.inHours.toString() ?? "";
      fenceRadiusController.text = branch.fenceRadius.toString();
    } else {
      nameController.clear();
      lastCheckInController.clear();
      fenceRadiusController.clear();
      isNew = true;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    lastCheckInController.dispose();
    fenceRadiusController.dispose();
    super.onClose();
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
