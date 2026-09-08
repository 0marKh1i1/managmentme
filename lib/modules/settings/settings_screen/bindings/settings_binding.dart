import 'package:get/get.dart';
import 'package:managementme/modules/settings/settings_screen/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController() , fenix: true);
  }
}
