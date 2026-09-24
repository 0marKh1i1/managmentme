import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/attendance_model.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/core/widgets/toast.dart';
import 'package:managementme/modules/admin/home/attendance_screen/controllers/attendance_controller.dart';
import 'package:managementme/modules/admin/home/attendance_screen/repo/attendance_repo.dart';

class AttendanceEditorController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLocked = true;
  bool get isLocked => _isLocked;
  bool get isEnabled => !_isLocked;

  bool isNew = false;
  bool isSaving = false;

  AttendanceModel? attendance;

  UserModel? selectedUser;
  BranchModel? selectedBranch;
  DateTime selectedDate = DateTime.now();
  TimeOfDay? checkInTime;
  TimeOfDay? checkOutTime;
  AttendanceStatus selectedStatus = AttendanceStatus.present;
  final TextEditingController notesController = TextEditingController();

  void initWith(AttendanceModel? attendance) {
    this.attendance = attendance;
    
    final attCtrl = Get.find<AttendanceController>();

    if (attendance != null) {
      selectedUser = attCtrl.getUser(attendance.userId);
      selectedBranch = attCtrl.getBranch(attendance.branchId);
      selectedDate = attendance.date;
      
      if (attendance.checkInTime != null) {
        checkInTime = TimeOfDay.fromDateTime(attendance.checkInTime!);
      }
      if (attendance.checkOutTime != null) {
        checkOutTime = TimeOfDay.fromDateTime(attendance.checkOutTime!);
      }
      selectedStatus = attendance.status;
      notesController.text = attendance.notes ?? '';
      isNew = false;
      setIsLocked(true);
    } else {
      selectedUser = null;
      selectedBranch = null;
      selectedDate = DateTime.now();
      checkInTime = TimeOfDay.now();
      checkOutTime = TimeOfDay.now();
      selectedStatus = AttendanceStatus.present;
      notesController.clear();
      isNew = true;
      setIsLocked(false);
    }

    update();
  }

  String get totalTimeText {
  if (checkInTime == null || checkOutTime == null) return '--:--';

  final inMinutes = checkInTime!.hour * 60 + checkInTime!.minute;
  var outMinutes = checkOutTime!.hour * 60 + checkOutTime!.minute;

  if (outMinutes < inMinutes) {
    outMinutes += 24 * 60;
  }

  return _fmt(outMinutes - inMinutes);
}

String _fmt(int totalMinutes) {
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  return '${hours}h ${minutes}m';
}

  void setIsLocked(bool b) {
    _isLocked = b;
    update();
  }

  bool toggleLock() {
    setIsLocked(!_isLocked);
    return isLocked;
  }

  void selectUser(UserModel user) {
    selectedUser = user;
    update();
  }

  void selectBranch(BranchModel branch) {
    selectedBranch = branch;
    update();
  }
  
  void selectStatus(AttendanceStatus status) {
    selectedStatus = status;
    update();
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate = picked;
      update();
    }
  }

  Future<void> pickCheckInTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: checkInTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      checkInTime = picked;
      update();
    }
  }

  Future<void> pickCheckOutTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: checkOutTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      checkOutTime = picked;
      update();
    }
  }

  Future<void> saveChanges() async {
    if (isSaving) return;

    if (selectedUser == null) {
      toast('error'.tr, 'please_select_user'.tr);
      return;
    }

    if (selectedBranch == null) {
      toast('error'.tr, 'please_select_branch'.tr);
      return;
    }

    if (checkInTime == null && checkOutTime == null) {
      toast('error'.tr, 'please_select_time'.tr);
      return;
    }

    isSaving = true;
    update();

    try {
      final docId =  AttendanceRepo.getAttendanceID(selectedDate, selectedUser!.id);

      DateTime? finalCheckIn;
      if (checkInTime != null) {
        finalCheckIn = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          checkInTime!.hour,
          checkInTime!.minute,
        );
      }

      DateTime? finalCheckOut;
      if (checkOutTime != null) {
        finalCheckOut = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          checkOutTime!.hour,
          checkOutTime!.minute,
        );
      }

      final updatedAttendance = AttendanceModel(
        id: docId,
        userId: selectedUser!.id,
        branchId: selectedBranch!.id,
        date: selectedDate,
        checkInTime: finalCheckIn,
        checkOutTime: finalCheckOut,
        status: selectedStatus,
        notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
        checkInLocation: attendance?.checkInLocation,
        checkOutLocation: attendance?.checkOutLocation,
      );

      await AttendanceRepo.saveAttendance(updatedAttendance);

      if (isClosed) return;
      
      Get.find<AttendanceController>().init();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
      toast('error'.tr, e.toString());
      isSaving = false;
      if (!isClosed) update();
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
