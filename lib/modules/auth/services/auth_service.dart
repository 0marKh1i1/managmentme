import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managementme/core/constants/firebase_options.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/widgets/toast.dart';

class AuthService extends GetxService {
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final Rx<BranchModel?> branch = Rx<BranchModel?>(null);

  StreamSubscription<DocumentSnapshot>? _userDocSubscription;
  StreamSubscription<DocumentSnapshot>? _branchDocSubscription;

  Future<AuthService> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      if (!e.toString().contains('duplicate-app')) {
        rethrow;
      }
    }
    return this;
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  Future<void> _setInitialScreen(User? user) async {
    if (user == null) {
      _clearUserData();
      if (Get.currentRoute != '/') Get.offAllNamed('/');
      return;
    }

    try {
      _userDocSubscription?.cancel();

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        await signOutWithError('user_not_found'.tr);
        return;
      }

      final data = doc.data();
      final isEnabled = data?['isEnabled'] ?? true;

      if (!isEnabled) {
        await signOutWithError('user_enable_error'.tr);
        return;
      }

      final userModel = UserModel.fromFirestore(doc);

      currentUser.value = userModel;

      if (Get.currentRoute != '/root') {
        Get.offAllNamed('/root');
      }

      _listenToUserUpdates(user.uid);
      _listenToBranchUpdates(userModel.branchId);
    } catch (e) {
      debugPrint('Error initializing user: $e');
      _clearUserData();
      Get.offAllNamed('/');
    }
  }

  void _listenToUserUpdates(String uid) {
    _userDocSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen(
          (snapshot) async {
            if (!snapshot.exists) {
              await signOutWithError('user_deleted'.tr);
              return;
            }

            final snapData = snapshot.data();
            final snapEnabled = snapData?['isEnabled'] ?? true;

            if (!snapEnabled) {
              await signOutWithError('user_enable_error'.tr);
            } else {
              final updatedUser = UserModel.fromFirestore(snapshot);
              currentUser.value = updatedUser;

              if (updatedUser.branchId != branch.value?.id) {
                _listenToBranchUpdates(updatedUser.branchId);
              }
            }
          },
          onError: (error) {
            debugPrint('Firestore subscription error: $error');
          },
        );
  }

  void _listenToBranchUpdates(String branchId) {
    _branchDocSubscription?.cancel();

    if (branchId.trim().isEmpty) {
      branch.value = null;
      return;
    }

    _branchDocSubscription = FirebaseFirestore.instance
    .collection('branches')
    .doc(branchId.trim())
    .snapshots()
    .listen(
      (snapshot) {
        if (!snapshot.exists) {
          branch.value = null;
          return;
        }
        branch.value = null; 
        branch.value = BranchModel.fromFirestore(snapshot);
      },
      onError: (error) {
        debugPrint('Branch subscription error: $error');
      },
    );
  }

  Future<BranchModel?> fetchBranch(String branchID) async {
    if (branchID.trim().isEmpty) return null;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('branches')
          .doc(branchID.trim())
          .get();
      return BranchModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('Error fetching branch: $e');
      return null;
    }
  }

  Future<void> signOutWithError(String errorMessage) async {
    toast('Error', errorMessage);
    await FirebaseAuth.instance.signOut();
    _clearUserData();
  }

  void _clearUserData() {
    _userDocSubscription?.cancel();
    _branchDocSubscription?.cancel();
    currentUser.value = null;
    branch.value = null;
  }

  @override
  void onClose() {
    _userDocSubscription?.cancel();
    _branchDocSubscription?.cancel();
    super.onClose();
  }
}
