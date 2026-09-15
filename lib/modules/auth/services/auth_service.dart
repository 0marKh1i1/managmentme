import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managementme/core/constants/firebase_options.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/widgets/toast.dart';

class AuthService extends GetxService {
  Rx<User?> firebaseUser = Rx<User?>(null);
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  
  StreamSubscription<DocumentSnapshot>? _userDocSubscription;

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
      _userDocSubscription?.cancel();
      currentUser.value = null;
      if (Get.currentRoute != '/') Get.offAllNamed('/');
    } else {
      try {
        _userDocSubscription?.cancel();
        
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
            
        if (doc.exists) {
          final data = doc.data();
          final isEnabled = data?['isEnabled'] ?? true;

          if (isEnabled == false) {
            toast('Error', 'user_enable_error'.tr);
            await FirebaseAuth.instance.signOut();
            return;
          }

          currentUser.value = UserModel.fromFirestore(doc);
          debugPrint('Current User: ${currentUser.value!.role}');
          
          if (Get.currentRoute != '/root') {
            Get.offAllNamed('/root');
          }

          _userDocSubscription = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots()
              .listen((snapshot) async {
                
            if (snapshot.exists) {
              final snapData = snapshot.data();
              final snapEnabled = snapData?['isEnabled'] ?? true;

              if (snapEnabled == false) {
                toast('Error', 'user_enable_error'.tr);
                await FirebaseAuth.instance.signOut();
              } else {
                currentUser.value = UserModel.fromFirestore(snapshot);
              }
            } else {
              await FirebaseAuth.instance.signOut();
            }
          });

        } else {
          await FirebaseAuth.instance.signOut();
        }
      } catch (e) {
        debugPrint('Error initializing user: $e');
        Get.offAllNamed('/');
      }
    }
  }

  Future<String> getInitialScreen() async {
    debugPrint('get initial screen');
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
          final data = doc.data();
          final isEnabled = data?['isEnabled'] ?? true;

          if (isEnabled == false) {
            await FirebaseAuth.instance.signOut();
            return '/';
          }

          currentUser.value = UserModel.fromFirestore(doc);
          return '/root';
        } else {
          await FirebaseAuth.instance.signOut();
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
  
  @override
  void onClose() {
    _userDocSubscription?.cancel();
    super.onClose();
  }
}