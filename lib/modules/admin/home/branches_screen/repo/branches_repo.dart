import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/branch_model.dart';

class BranchesRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final User? _curentUser = FirebaseAuth.instance.currentUser;

  static Future<void> createBranch(BranchModel branch) async {
    if (_curentUser == null) {
      Get.offAndToNamed("/");
      return;
    }

    await _firestore
        .collection("branches")
        .add(branch.toFirestore());
  }

  static Future<void> updatBranch(BranchModel branch) async {
    if (_curentUser == null) {
      Get.offAndToNamed("/");
      return;
    }

    await _firestore
        .collection("branches")
        .doc(branch.id)
        .update(branch.toFirestore());
  }
}
