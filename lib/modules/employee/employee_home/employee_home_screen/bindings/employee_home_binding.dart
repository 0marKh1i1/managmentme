import 'package:managementme/modules/employee/employee_home/employee_home_screen/controllers/employee_home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EmployeeHomeController>(EmployeeHomeController());
  }
}
