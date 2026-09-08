import 'package:firebase_auth/firebase_auth.dart';

class LoginRepo {
   static Future<UserCredential> login({required String email, required String pass}) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception('Error: ${e.code}');
      }
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }
}
