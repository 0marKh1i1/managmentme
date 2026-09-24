import 'package:cloud_firestore/cloud_firestore.dart';

enum AttendanceStatus { present, late, absent, earlyLeave, out}

class AttendanceModel {
  final String id;
  final String userId;
  final String branchId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final GeoPoint? checkInLocation;
  final GeoPoint? checkOutLocation;
  final AttendanceStatus status;
  final String? notes;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.branchId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLocation,
    this.checkOutLocation,
    this.status = AttendanceStatus.present,
    this.notes,
  });

  AttendanceModel copyWith({
    String? id,
    String? userId,
    String? branchId,
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    GeoPoint? checkInLocation,
    GeoPoint? checkOutLocation,
    AttendanceStatus? status,
    String? notes,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      branchId: branchId ?? this.branchId,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkInLocation: checkInLocation ?? this.checkInLocation,
      checkOutLocation: checkOutLocation ?? this.checkOutLocation,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AttendanceModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      branchId: data['branchId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      checkInTime: data['checkInTime'] != null
          ? (data['checkInTime'] as Timestamp).toDate()
          : null,
      checkOutTime: data['checkOutTime'] != null
          ? (data['checkOutTime'] as Timestamp).toDate()
          : null,
      checkInLocation:(data['checkInLocation'] as GeoPoint?),
      checkOutLocation: (data['checkOutLocation'] as GeoPoint?),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => AttendanceStatus.present,
      ),
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'branchId': branchId,
      'date': Timestamp.fromDate(date),
      if (checkInTime != null) 'checkInTime': Timestamp.fromDate(checkInTime!),
      if (checkOutTime != null) 'checkOutTime': Timestamp.fromDate(checkOutTime!),
      if (checkInLocation != null) 'checkInLocation': checkInLocation,
      if (checkOutLocation != null) 'checkOutLocation': checkOutLocation,
      'status': status.name,
      if (notes != null) 'notes': notes,
    };
  }
}
