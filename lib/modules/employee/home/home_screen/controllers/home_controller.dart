import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/modules/employee/home/home_screen/repo/home_repo.dart';

class HomeController extends GetxController {
  BranchModel? branch;
  Future<void> fetchBranch(String branchID) async {
    if (branchID.isEmpty) return;
    branch = await HomeRepo.getBranch(branchID);
    update();
  }
}
