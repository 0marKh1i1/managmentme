import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/attendance_model.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managementme/modules/admin/home/attendance_screen/repo/attendance_repo.dart';
import 'package:managementme/modules/auth/services/auth_service.dart';

class EmployeeHomeRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<BranchModel> getBranch(String branchID) async {
    final doc = await _firestore.collection('branches').doc(branchID).get();
    return BranchModel.fromFirestore(doc);
  }

  static Future<void> saveAttendance(AttendanceModel attendance) async {
    if (FirebaseAuth.instance.currentUser == null) {
      Get.offAndToNamed("/");
      return;
    }

    await _firestore
        .collection("attendances")
        .doc(attendance.id)
        .set(attendance.toMap(), SetOptions(merge: true));
  }

  static Future<void> setCheckStatus(bool isIn) async {
    if (FirebaseAuth.instance.currentUser == null) return;
    await _firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'isCheckedIn': isIn})
        .onError((error, stackTrace) async {
          await Get.find<AuthService>().signOutWithError("no_user_found".tr);
        });
  }

  static Future<AttendanceModel?> getAttendanceRecord(
    DateTime time,
    String usrID,
  ) async {
    final docId = AttendanceRepo.getAttendanceID(time, usrID);
    try {
      final doc = await _firestore
          .collection("attendances")
          .doc(docId)
          .get();
      return AttendanceModel.fromFirestore(doc);
    } catch (_) {
      return null;
    }
  }
}
