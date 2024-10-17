import 'package:cloud_firestore/cloud_firestore.dart';

class RouteSchedule {
  String id;
  DateTime scheduleDate;
  String routeId;
  String driverId;

  RouteSchedule(
      {this.id = '',
      required this.scheduleDate,
      required this.routeId,
      required this.driverId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scheduleDate': scheduleDate,
      'routeId': routeId,
      'driverId': driverId,
    };
  }

  factory RouteSchedule.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RouteSchedule(
      id: doc.id,
      scheduleDate: (data['scheduleDate'] as Timestamp).toDate(),
      routeId: data['routeId'],
      driverId: data['driverId'],
    );
  }
}
