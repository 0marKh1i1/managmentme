import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/modules/admin/home/home_screen/repo/home_repo.dart';

class EmployeesController extends GetxController {
  bool isLoading = true;
  Map<String,BranchModel> branches = {};
  List<BranchModel> branchesList = [];

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    try {
      await _fetchBranches();
    } catch (e) {
      debugPrint("Error initializing data: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  BranchModel? getBranch(String branchId) {
    return branches[branchId];
  }

  Future<void> _fetchBranches() async {
    branches = await HomeRepo.getBranchs();
    branchesList = branches.values.toList();
  }
}
