import 'package:managementme/modules/employee/employee_home/employee_home_screen/repo/employee_home_repo.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:managementme/core/models/branch_model.dart';

class EmployeeHomeController extends GetxController {
  BranchModel? branch;
  Future<void> fetchBranch(String branchID) async {
    if (branchID.isEmpty) return;
    branch = await EmployeeHomeRepo.getBranch(branchID);
    update();
  }
}
