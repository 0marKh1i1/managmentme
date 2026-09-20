import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/modules/admin/home/home_screen/repo/home_repo.dart';

class BranchesController extends GetxController {
  List<BranchModel> branchesList = [];
  bool isLoading = true;

  Future<void> fetchBranches() async {
    final branches = await HomeRepo.getBranchs();
    branchesList = branches.values.toList();
    update();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    try {
      isLoading = true;
      update();

      await fetchBranches();
    } catch (e) {
      debugPrint("Error initializing data: $e");
    } finally {
      isLoading = false; 
      update();
    }
  }
  
}
