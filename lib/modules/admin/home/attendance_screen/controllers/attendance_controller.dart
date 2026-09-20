import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/attendance_model.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/modules/admin/home/attendance_screen/repo/attendance_repo.dart';
import 'package:managementme/modules/admin/home/home_screen/repo/home_repo.dart';

class AttendanceController extends GetxController {
  List<AttendanceModel> attendancesList = [];
  Map<String, UserModel> usersMap = {};
  Map<String, BranchModel> branchesMap = {};
  bool isLoading = true;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    try {
      isLoading = true;
      update();

      await fetchAttendances();
      await fetchUsersAndBranches();
    } catch (e) {
      debugPrint("Error initializing attendance data: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchAttendances() async {
    attendancesList = await AttendanceRepo.getAttendances();
  }

  Future<void> fetchUsersAndBranches() async {
    final employees = await HomeRepo.getEmployees();
    for (var emp in employees) {
      usersMap[emp.id] = emp;
    }

    branchesMap = await HomeRepo.getBranchs();
  }

  UserModel? getUser(String userId) => usersMap[userId];
  BranchModel? getBranch(String branchId) => branchesMap[branchId];
}
