import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  final String id;
  final String name;
  final Duration? lastCheckInTime; 
  final GeoPoint? location;
  final double? fenceRadius;

  BranchModel({
    required this.id,
    required this.name,
    this.lastCheckInTime = const Duration(hours: 9, minutes: 0),
    this.location,
    this.fenceRadius,
  });

  factory BranchModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BranchModel(
      id: doc.id,
      name: data['name'] ?? '',
      lastCheckInTime: data['lastCheckInTime'] != null
          ? Duration(minutes: data['lastCheckInTime'])
          : const Duration(hours: 9, minutes: 0),
      location: data['location'] as GeoPoint?,
      fenceRadius: (data['fenceRadius'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'lastCheckInTime': lastCheckInTime?.inMinutes,
      if (location != null) 'location': location,
      if (fenceRadius != null) 'fenceRadius': fenceRadius,
    };
  }
}