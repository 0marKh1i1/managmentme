import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/core/utils/format_duration.dart';
import 'package:managementme/modules/auth/services/auth_service.dart';
import 'package:managementme/core/models/branch_model.dart';

class EmployeeHomeController extends GetxController {

  bool isLoading = true;

  final AuthService _authService = Get.find<AuthService>();
  UserModel? get user => _authService.currentUser.value;
  BranchModel? get branch => _authService.branch.value;

  @override
  void onInit() {
    super.onInit();
    everAll([
      _authService.currentUser,
      _authService.branch,
    ], (_) => _initData());

    _initData();
  }

  Future<void> _initData() async {
    try {
      isLoading = true;
      update();

      if (user == null) return;
    } catch (e) {
      debugPrint("Error initializing data in EmployeeHomeController: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  // getters
  String get branchName => branch?.name ?? "unknown_branch".tr;

  String get branchWorkingHours => branch?.workingHours.toHHMM() ?? "--";

  static final DateFormat _timeFormatter = DateFormat('hh:mm a');
  String get checkInTime => user?.checkInTime != null
      ? _timeFormatter.format(user!.checkInTime!)
      : '--:--';

  String get checkOutTime => user?.checkOutTime != null
      ? _timeFormatter.format(user!.checkOutTime!)
      : '--:--';
}
