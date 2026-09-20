import 'package:get/get.dart';
import 'package:managementme/modules/admin/home/attendance_screen/controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AttendanceController>(AttendanceController());
  }
}
