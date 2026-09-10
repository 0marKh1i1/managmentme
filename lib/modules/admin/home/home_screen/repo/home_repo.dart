import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';

class HomeRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<UserModel>> getEmployees() async {
    late CollectionReference empCollection = _firestore.collection('users');
    QuerySnapshot empSnapshot = await empCollection.get();
    List<UserModel> empList = empSnapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList();
    return empList;
  }

  static Future<BranchModel> getBranch(String branchId) async {
    return await _firestore.collection('branches').doc(branchId).get().then((
      doc,
    ) {
      if (doc.exists) {
        return BranchModel.fromFirestore(doc);
      } else {
        throw Exception('Branch not found');
      }
    });
  }

  static Future<Map<String, BranchModel>> getBranchs() async {
    final snapshot = await _firestore.collection('branches').get();

    return {
      for (var doc in snapshot.docs) doc.id: BranchModel.fromFirestore(doc),
    };
  }
}
