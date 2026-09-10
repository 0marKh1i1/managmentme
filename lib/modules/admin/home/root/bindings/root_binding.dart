import 'package:get/get.dart';
import 'package:managementme/modules/admin/home/home_screen/controllers/home_controller.dart';
import 'package:managementme/modules/admin/home/root/controllers/root_controller.dart';
import 'package:managementme/modules/settings/settings_screen/controllers/settings_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RootController>(RootController());
    Get.put<HomeController>(HomeController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
