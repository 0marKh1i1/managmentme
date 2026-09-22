import 'dart:io';

import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class SettingsRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static DocumentReference<Map<String, dynamic>>? get _userInfoDoc {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore.collection('users').doc(user.uid);
  }

  static Stream<UserModel?> getUserStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    final docRef = _userInfoDoc;
    if (docRef == null) return Stream.value(null);

    return docRef.snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        _seedUserDoc(user);
        return UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          branchId: '',
          photoUrl: user.photoURL,
          phone: user.phoneNumber ?? '',
          role: UserType.employee,
        );
      }
      return UserModel.fromFirestore(snapshot);
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

  static Future<BranchModel> getBranch(String branchID) async {
    final doc = await _firestore.collection('branches').doc(branchID).get();
    return BranchModel.fromFirestore(doc);
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }
}
