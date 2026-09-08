import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managementme/firebase_options.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  Rx<User?> firebaseUser = Rx<User?>(null);
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

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

  void _setInitialScreen(User? user) async {
    if (user == null) {
      currentUser.value = null;
      if (Get.currentRoute != '/') Get.offAllNamed('/');
    } else {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          currentUser.value = UserModel.fromFirestore(doc);
          debugPrint('Current User: ${currentUser.value!.role}');
          switch (currentUser.value!.role) {
            case UserType.admin:
              Get.offAllNamed('/admin/root');
              break;
            case UserType.driver:
              Get.offAllNamed('/driver/root');
              break;
            case UserType.customer:
              Get.offAllNamed('/customer/root');
              break;
          }
        } else {
          Get.offAllNamed('/');
        }
      } catch (e) {
        Get.offAllNamed('/');
      }
    }
  }
  Future<String> getInitialScreen() async {
    debugPrint('get inital screen');
    
      User? user = getUser();

    if (user == null) {
      return '/';
    } else {
      try {
           final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          currentUser.value = UserModel.fromFirestore(doc);
          debugPrint('Current User: ${currentUser.value!.role}');
          switch (currentUser.value!.role) {
            case UserType.admin:
              return '/admin/root';
            case UserType.driver:
              return '/driver/root';
            case UserType.customer:
              return '/customer/root';
          }
        } else {
          return '/';
        }
      } catch (e) {
        return '/';
      }
    }
  }

  User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
