import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:managementme/core/models/attendance_model.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/core/utils/format_duration.dart';
import 'package:managementme/core/utils/location_utils.dart';
import 'package:managementme/core/widgets/toast.dart';
import 'package:managementme/modules/auth/services/auth_service.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/modules/employee/employee_home/employee_home_screen/repo/employee_home_repo.dart';

class EmployeeHomeController extends GetxController {
  bool isLoading = true;
  bool isSaving = false;

  final AuthService _authService = Get.find<AuthService>();
  UserModel? get user => _authService.currentUser.value;
  BranchModel? get branch => _authService.branch.value;
  AttendanceModel? attendanceToday;

  @override
  void onInit() {
    super.onInit();
    everAll([_authService.currentUser, _authService.branch], (_) {
      _initData();
    });

    _initData();
  }

  Future<void> _initData() async {
    try {
      isLoading = true;
      update();
      await _fetchAttendanceRecord();
    } catch (e) {
      debugPrint("Error initializing data in EmployeeHomeController: $e");
    } finally {
      if (user == null || branch == null) {
        isLoading = true;
      } else {
        isLoading = false;
      }
      update();
    }
  }

  Future<AttendanceModel?> _fetchAttendanceRecord() async {
    DateTime today = DateTime.now();
    String usrID = user!.id;
    attendanceToday = await EmployeeHomeRepo.getAttendanceRecord(today, usrID);
    return attendanceToday;
  }

  bool isWithinRadius(GeoPoint point1, GeoPoint point2, double radiusInMeters) {
    double distanceInMeters = Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
    return distanceInMeters <= radiusInMeters;
  }

  Future<void> onClockButton() async {
    if (isSaving) return;
    if (user == null || branch == null) return;

    isSaving = true;
    update();

    try {
      DateTime today = DateTime.now();

      final dateOnlyStr = DateFormat('yyyy-MM-dd').format(today);
      final docId = "${user!.id}_$dateOnlyStr";

      Position position = await LocationUtils.determinePosition();
      GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);
      if (!isWithinRadius(geoPoint, branch!.location, branch!.fenceRadius)) {
        throw Exception('outside_of_location'.tr);
      }

      GeoPoint? finalCheckInLocation;
      GeoPoint? finalCheckOutLocation;
      DateTime? finalCheckInTime;
      DateTime? finalCheckOutTime;

      if (user!.isCheckedIn) {
        finalCheckOutTime = today;
        finalCheckOutLocation = geoPoint;
      } else {
        finalCheckInTime = today;
        finalCheckInLocation = geoPoint;
      }

      AttendanceStatus finalStatus = getAttendanceStatus(user!, branch!, today);

      final updatedAttendance = AttendanceModel(
        id: docId,
        userId: user!.id,
        branchId: branch!.id,
        date: today,
        checkInTime: finalCheckInTime,
        checkOutTime: finalCheckOutTime,
        checkInLocation: finalCheckInLocation,
        checkOutLocation: finalCheckOutLocation,
        status: finalStatus,
      );

      await Future.wait([
        EmployeeHomeRepo.saveAttendance(updatedAttendance),
        EmployeeHomeRepo.setCheckStatus(
          finalStatus == AttendanceStatus.present ||
              finalStatus == AttendanceStatus.late,
        ),
      ]);

      if (isClosed) return;
      isSaving = false;
      update();
    } catch (e) {
      debugPrint(e.toString());
      final message = e.toString().replaceFirst('Exception: ', '');
      toast('error'.tr, message);
      isSaving = false;
      if (!isClosed) update();
    }
  }

  // getters
  String get branchName => branch?.name ?? 'unknown_branch'.tr;

  String get branchWorkingHours => branch?.workingHours.toHHMM() ?? "--";

  static final DateFormat _timeFormatter = DateFormat('hh:mm a');
  String get checkInTimeStr {
    try {
      return _timeFormatter.format(attendanceToday!.checkInTime!);
    } catch (e) {
      return '--:--';
    }
  }

  String get checkOutTimeStr {
    try {
      return _timeFormatter.format(attendanceToday!.checkOutTime!);
    } catch (e) {
      return '--:--';
    }
  }

  String get checkButtonStr =>
      user?.isCheckedIn == false ? "clock_in".tr : "clock_out".tr;

  AttendanceStatus getAttendanceStatus(
    UserModel user,
    BranchModel branch,
    DateTime time,
  ) {
    DateTime today = time;
    Duration branchLastInTime = branch.lastCheckInTime;
    Duration branchworkingHours = branch.workingHours;
    DateTime midnight = DateTime(today.year, today.month, today.day);
    DateTime lastInTime = midnight.add(branchLastInTime);
    DateTime? lastOutTime;
    AttendanceStatus localStatus;

    if (!user.isCheckedIn) {
      if (today.isAfter(lastInTime)) {
        localStatus = AttendanceStatus.late;
      } else {
        localStatus = AttendanceStatus.present;
      }
    } else {
      lastOutTime = attendanceToday?.checkInTime?.add(branchworkingHours);
      if (lastOutTime == null || attendanceToday?.checkInTime == null) {
        return AttendanceStatus.absent;
      }
      if (lastOutTime.isAfter(today)) {
        localStatus = AttendanceStatus.earlyLeave;
      } else {
        localStatus = AttendanceStatus.out;
      }
    }
    return localStatus;
  }
}
