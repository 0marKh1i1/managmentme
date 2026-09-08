import 'package:get/get.dart';
import 'package:managementme/modules/home/home_screen/controllers/home_controller.dart';
import 'package:managementme/modules/profile/profile_screen/controllers/profile_controller.dart';
import 'package:managementme/modules/home/root/controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RootController>(RootController());
    Get.put<HomeController>(HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
