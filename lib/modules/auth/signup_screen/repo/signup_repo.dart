import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupRepo {
  static Future<UserCredential> createUser({
    required String email,
    required String phone,
    required String pass,
    required String username,
    required UserType role,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      await credential.user?.updateDisplayName(username);

      final uid = credential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': username,
        'email': email,
        'phone': phone,
        'photoUrl': '',
        'role': role.name,
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        throw Exception("The account already exists for that email.");
      } else {
        throw Exception('Error: ${e.code}');
      }
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }
}
