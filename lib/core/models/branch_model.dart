import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  final String id;
  final String name;
  final Duration lastCheckInTime;
  final Duration workingHours;
  final GeoPoint location;
  final double fenceRadius;

  BranchModel({
    required this.id,
    required this.name,
    required this.location,
    required this.fenceRadius,
    this.lastCheckInTime = const Duration(hours: 9),
    this.workingHours = const Duration(hours: 8),
  });

  Duration get firstCheckOutTime => lastCheckInTime + workingHours;

  Duration checkOutFor(Duration checkIn) => checkIn + workingHours;

  BranchModel copyWith({
    String? id,
    String? name,
    Duration? lastCheckInTime,
    Duration? workingHours,
    GeoPoint? location,
    double? fenceRadius,
  }) {
    return BranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      lastCheckInTime: lastCheckInTime ?? this.lastCheckInTime,
      workingHours: workingHours ?? this.workingHours,
      location: location ?? this.location,
      fenceRadius: fenceRadius ?? this.fenceRadius,
    );
  }

  factory BranchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BranchModel(
      id: doc.id,
      name: data['name'] ?? '',
      lastCheckInTime: data['lastCheckInTime'] != null
          ? Duration(minutes: data['lastCheckInTime'])
          : const Duration(hours: 9),
      workingHours: data['workingHours'] != null
          ? Duration(minutes: data['workingHours'])
          : const Duration(hours: 8),
      location: data['location'] as GeoPoint,
      fenceRadius: (data['fenceRadius'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'lastCheckInTime': lastCheckInTime.inMinutes,
        'workingHours': workingHours.inMinutes,
        'location': location,
        'fenceRadius': fenceRadius,
      };
}