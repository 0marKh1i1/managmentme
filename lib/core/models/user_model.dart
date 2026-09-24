import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { employee, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType role;
  final String branchId;
  final String? photoUrl;
  final bool isCheckedIn;
  final bool isEnabled;
  

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.branchId,
    this.isCheckedIn = false,
    this.isEnabled = true,
    this.photoUrl,
  });
  
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserType? role,
    String? branchId,
    String? photoUrl,
    bool? isCheckedIn,
    bool? isEnabled,

  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      branchId: branchId ?? this.branchId,
      photoUrl: photoUrl ?? this.photoUrl,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      branchId: data['branchId'] ?? '',
      isCheckedIn: data['isCheckedIn'] ?? false,
      isEnabled: data['isEnabled'] ?? true,
      photoUrl: data['photoUrl'],
      role: UserType.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => UserType.employee,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'branchId': branchId,
      'isCheckedIn': isCheckedIn,
      'isEnabled': isEnabled,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
