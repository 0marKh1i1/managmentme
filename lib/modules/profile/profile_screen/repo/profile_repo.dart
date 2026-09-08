import 'dart:io';

import 'package:managementme/modules/profile/profile_screen/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static DocumentReference<Map<String, dynamic>>? get _userInfoDoc {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('info')
        .doc(user.uid);
  }

  /// Get real time stream of user profile from Firestore
  /// Falls back to Firebase Auth data if Firestore doc doesnt exist yet
  static Stream<UserModel?> getUserStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    final docRef = _userInfoDoc;
    if (docRef == null) return Stream.value(null);

    return docRef.snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        // Auto seed from Firebase Auth profile if Firestore doc is missing
        _seedUserDoc(user);
        return UserModel(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: user.photoURL ?? '',
        );
      }
      return UserModel.fromJson(snapshot.data()!);
    });
  }

  static Future<void> _seedUserDoc(User user) async {
    final docRef = _userInfoDoc;
    if (docRef == null) return;
    await docRef.set({
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
    }, SetOptions(merge: true));
  }

  /// Updates the user's display name in Firestore and Firebase Auth.
  static Future<void> updateName(String newName) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final docRef = _userInfoDoc;
    if (docRef == null) throw Exception('User not logged in');

    await Future.wait([
      docRef.update({'name': newName}),
      user.updateDisplayName(newName),
    ]);
  }

  /// Uploads a profile image to Firebase Storage and updates photoUrl in Firestore
  static Future<void> updateProfileImage(XFile imageFile) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final docRef = _userInfoDoc;
    if (docRef == null) throw Exception('User not logged in');

    final storageRef = _storage.ref().child('profile_images/${user.uid}');

    final file = File(imageFile.path);
    final uploadTask = await storageRef.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    await Future.wait([
      docRef.update({'photoUrl': downloadUrl}),
      user.updatePhotoURL(downloadUrl),
    ]);
  }

  /// Removes the profile photo 
  static Future<void> removeProfileImage() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final docRef = _userInfoDoc;
    if (docRef == null) throw Exception('User not logged in');

    await Future.wait([
      docRef.update({'photoUrl': ''}),
      user.updatePhotoURL(null),
    ]);
  }

  /// Signs the user out 
  static Future<void> logout() async {
    await _auth.signOut();
  }
}
