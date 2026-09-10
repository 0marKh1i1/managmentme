import 'package:get/get.dart';
import 'package:managementme/modules/admin/home/employees_screen/controllers/employees_controller.dart';

class EmployeesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EmployeesController>(EmployeesController());
  }
}