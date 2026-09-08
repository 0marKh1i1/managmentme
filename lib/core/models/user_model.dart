import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { driver, customer, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType role;
  final Map<String, dynamic>? currentLocation;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.currentLocation,
    this.photoUrl,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: UserType.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => UserType.customer,
      ),
      currentLocation: data['currentLocation'] != null
          ? Map<String, dynamic>.from(data['currentLocation'])
          : null,
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      if (currentLocation != null) 'currentLocation': currentLocation,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
