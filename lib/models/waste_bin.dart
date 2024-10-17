import 'package:cloud_firestore/cloud_firestore.dart';

class WasteBin {
  String id;
  String routeId;
  String binType;
  double longitude;
  double latitude;

  WasteBin(
      {this.id = '',
      required this.routeId,
      required this.binType,
      required this.longitude,
      required this.latitude});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'routeId': routeId,
      'binType': binType,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory WasteBin.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WasteBin(
      id: doc.id,
      routeId: data['routeId'],
      binType: data['binType'],
      longitude: data['longitude'],
      latitude: data['latitude'],
    );
  }
}
