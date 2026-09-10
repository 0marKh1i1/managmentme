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
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final GeoPoint? checkInLocation;
  final GeoPoint? checkOutLocation;
  

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.branchId,
    this.isCheckedIn = false,
    this.photoUrl,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLocation,
    this.checkOutLocation,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      branchId: data['branchId'] ?? '',
      isCheckedIn: data['isCheckedIn'] ?? false,
      photoUrl: data['photoUrl'],
      role: UserType.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => UserType.employee,
      ),
      checkInTime: data['checkInTime'] != null
          ? (data['checkInTime'] as Timestamp).toDate()
          : null,
      checkOutTime: data['checkOutTime'] != null
          ? (data['checkOutTime'] as Timestamp).toDate()
          : null,
      checkInLocation: data['checkInLocation'] != null
          ? (data['checkInLocation'] as GeoPoint)
          : null,
      checkOutLocation: data['checkOutLocation'] != null
          ? (data['checkOutLocation'] as GeoPoint)
          : null,
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
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (checkInTime != null) 'checkInTime': Timestamp.fromDate(checkInTime!),
      if (checkOutTime != null) 'checkOutTime': Timestamp.fromDate(checkOutTime!),
      if (checkInLocation != null) 'checkInLocation': checkInLocation,
      if (checkOutLocation != null) 'checkOutLocation': checkOutLocation,
    };
  }
}
