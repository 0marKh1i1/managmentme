
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';

class HomeRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static Future<List<UserModel>> getEmployeeStats() async {
    late CollectionReference empCollection = _firestore.collection('users');
    QuerySnapshot empSnapshot = await empCollection.get();
    List<UserModel> empList = empSnapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    debugPrint('Fetched ${empList.length} employees from Firestore');
    return empList;
  }
  static Future<BranchModel> getBranch(String branchId) async {
    return await _firestore.collection('branches').doc(branchId).get().then((doc) {
      if (doc.exists) {
        return BranchModel.fromFirestore(doc);
      } else {
        throw Exception('Branch not found');
      }
    });
  }
}
