import 'package:get/get.dart';
import 'package:managementme/modules/profile/profile_screen/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
