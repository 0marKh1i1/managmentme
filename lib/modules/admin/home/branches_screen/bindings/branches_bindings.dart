import 'package:get/get.dart';
import 'package:managementme/modules/admin/home/branches_screen/controllers/branches_cotroller.dart';

class BranchesBindings extends Bindings{
   @override
  void dependencies() {
    Get.put<BranchesCotroller>(BranchesCotroller());
  }
}