
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managementme/core/models/branch_model.dart';

class HomeRepo {
    static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    static Future<BranchModel> getBranch(String branchID) async {
    final doc = await _firestore.collection('branches').doc(branchID).get();
    return BranchModel.fromFirestore(doc);
  }
}
