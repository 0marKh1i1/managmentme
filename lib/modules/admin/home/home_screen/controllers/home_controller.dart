import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/modules/admin/home/home_screen/repo/home_repo.dart';

class HomeController extends GetxController {
   bool isLoading = true;
  
  List<UserModel> employees = [];
  int lateEmployeesCount = 0;
  int presentEmployees = 0;
  int absentEmployees = 0;

  @override
  void onInit() {
    init();
    super.onInit();
  }

 void init() async {
    try {
      isLoading = true;
      update();

      await _fetchEmployees();
      
      await Future.wait([
        _fetchLateEmployees(),
        Future.value(_fetchtPresentEmployees()),
        Future.value(_fetchAbsentEmployees()),
      ]);
    } catch (e) {
      debugPrint("Error initializing data: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> _fetchEmployees() async {
    employees = await HomeRepo.getEmployees();
  }

  int _fetchtPresentEmployees() {
    presentEmployees = employees.where((e) => e.isCheckedIn).length;
    return presentEmployees;
    // todo add actual logic to determine if an employee is present like if the location is within the work area and if they are checked in
  }

  int _fetchAbsentEmployees() {
    absentEmployees = employees.where((e) => !e.isCheckedIn).length;
    return absentEmployees;
  }

  Future<int> _fetchLateEmployees() async {
    
    List<Future<bool>> futures = employees
        .map((e) => _isEmployeeLate(e))
        .toList();
    List<bool> results = await Future.wait(futures);
    
    int lateCount = results.where((isLate) => isLate).length;
    lateEmployeesCount = lateCount;

    return lateCount;
  }

  Future<bool> _isEmployeeLate(UserModel employee) async {
    DateTime today = DateTime.now();
    DateTime todayDateOnly = DateTime(today.year, today.month, today.day);

    final branchId = employee.branchId;

    if (employee.checkInTime == null) return false;
    if (branchId.isEmpty) return false;

    final lastCheckInTimeOnly =
        await HomeRepo.getBranch(
          branchId,
        ).then((branch) => branch.lastCheckInTime).catchError((e) {
          debugPrint("branch time check in Error: $e");
          return Duration(minutes: 0);
        }) ??
        Duration(minutes: 0);

    DateTime lastCheckIn = todayDateOnly.add(lastCheckInTimeOnly);

    return employee.checkInTime!.isAfter(lastCheckIn);
  }

  int getCheckedOutEmployees() {
    // todo
    return 0;
  }

  int getOutsideWorkAreaEmployees() {
    // todo
    return 0;
  }
  
}
