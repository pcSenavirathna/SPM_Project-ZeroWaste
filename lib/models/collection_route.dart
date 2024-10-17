import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionRoute {
  String id;
  String startLocation;
  String endLocation;
  double startLongitude;
  double startLatitude;
  double endLongitude;
  double endLatitude;

  CollectionRoute({
    required this.id,
    required this.startLocation,
    required this.endLocation,
    required this.startLongitude,
    required this.startLatitude,
    required this.endLongitude,
    required this.endLatitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startLongitude': startLongitude,
      'startLatitude': startLatitude,
      'endLongitude': endLongitude,
      'endLatitude': endLatitude,
    };
  }

  factory CollectionRoute.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CollectionRoute(
      id: data['id'],
      startLocation: data['startLocation'],
      endLocation: data['endLocation'],
      startLongitude: data['startLongitude'],
      startLatitude: data['startLatitude'],
      endLongitude: data['endLongitude'],
      endLatitude: data['endLatitude'],
    );
  }
}
