import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/branch_model.dart';

class BranchesEditorController extends GetxController{
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  
  bool _isLocked = true;
  bool get isLoacked => _isLocked;
  bool get isEnabled => !_isLocked;

  void initWith(BranchModel? branch){
    if (branch != null) {

    } else {
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

}
