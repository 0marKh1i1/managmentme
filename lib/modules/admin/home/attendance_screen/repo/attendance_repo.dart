import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:managementme/core/models/attendance_model.dart';

class AttendanceRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final User? _curentUser = FirebaseAuth.instance.currentUser;

  static Future<List<AttendanceModel>> getAttendances() async {
    if (_curentUser == null) {
      Get.offAndToNamed("/");
      return [];
    }

    final snapshot = await _firestore
        .collection("attendances")
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AttendanceModel.fromFirestore(doc))
        .toList();
  }

  static Future<void> saveAttendance(AttendanceModel attendance) async {
    if (_curentUser == null) {
      Get.offAndToNamed("/");
      return;
    }

    await _firestore
        .collection("attendances")
        .doc(attendance.id)
        .set(attendance.toMap(), SetOptions(merge: true));
  }

  static String getAttendanceID(DateTime time , String usrID){
    final dateOnlyStr = DateFormat('yyyy-MM-dd').format(time);
    final docID = "${usrID}_$dateOnlyStr"; 
    return docID;
  }
}
