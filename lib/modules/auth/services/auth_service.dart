import 'package:managementme/core/constants/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  Rx<User?> firebaseUser = Rx<User?>(null);

  Future<AuthService> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return this;
  }

  @override
  void onReady() {
    super.onReady();

    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());

    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      if (Get.currentRoute != '/') Get.offAllNamed('/');
    } else {
      if (Get.currentRoute != '/root') Get.offAllNamed('/root');
    }
  }

  User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
