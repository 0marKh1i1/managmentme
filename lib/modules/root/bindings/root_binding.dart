import 'package:get/get.dart';
import 'package:managementme/modules/admin/home/home_screen/controllers/home_controller.dart';
import 'package:managementme/modules/employee/employee_home/employee_home_screen/controllers/employee_home_controller.dart';
import 'package:managementme/modules/root/controllers/root_controller.dart';
import 'package:managementme/modules/settings/settings_screen/controllers/settings_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RootController>(RootController(), permanent: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<EmployeeHomeController>(() => EmployeeHomeController(), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
  }
}
