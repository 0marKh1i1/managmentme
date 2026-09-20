import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/branch_model.dart';
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

  static Future<void> createEmployeeByAdmin({
    required String email,
    required String phone,
    required String pass,
    required String username,
    required UserType role,
    required bool isEnabled,
    required bool isCheckedIn,
    BranchModel? branch,
  }) async {
    FirebaseApp secondaryApp = await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: Firebase.app().options,
    );

    try {
      UserCredential credential = await FirebaseAuth.instanceFor(
        app: secondaryApp,
      ).createUserWithEmailAndPassword(email: email, password: pass);

      final uid = credential.user!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(
            UserModel(
              id: uid,
              name: username,
              email: email,
              phone: phone,
              role: role,
              branchId: branch == null ? "" : branch.id,
              isEnabled: isEnabled,
              isCheckedIn: isCheckedIn
            ).toMap(),
          );

      await FirebaseAuth.instanceFor(app: secondaryApp).signOut();
      await secondaryApp.delete();
    } catch (e) {
      debugPrint("Error creating employee: $e");
      await secondaryApp.delete();
      rethrow;
    }
  }
}
