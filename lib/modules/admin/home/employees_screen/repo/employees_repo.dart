import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/user_model.dart';

class EmployeesRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final User? _curentUser = FirebaseAuth.instance.currentUser;

  static Future<void> updateUser(UserModel user) async {
    if (_curentUser == null) {
      Get.offAndToNamed("/");
      return;
    }
    
    await _firestore.collection("users").doc(user.id).update(user.toMap());
  }
}
