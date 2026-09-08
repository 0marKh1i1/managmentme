import 'package:get/get.dart';
import 'package:managementme/modules/auth/signup_screen/controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController() , fenix: true);
  }
}
