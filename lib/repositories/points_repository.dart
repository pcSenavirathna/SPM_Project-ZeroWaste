import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/points.dart';
import 'package:zero_waste/utils/app_logger.dart';

class PointsRepository {
  final CollectionReference _pointsCollection =
      FirebaseFirestore.instance.collection('points');

  Future<Points?> getPointDetails() async {
    try {
      DocumentSnapshot doc = await _pointsCollection.doc('current').get();
      if (doc.exists) {
        return Points.fromDocument(doc);
      } else {
        AppLogger.printError('No details Found');
        throw Exception('No details Found');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error fetching points details: $e');
    }
  }

  Future<void> createPoints(Points points) async {
    try {
      await _pointsCollection.doc('current').set(points.toMap());
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error creating points details: $e');
    }
  }

  Future<void> updatePoints(Points points) async {
    try {
      final doc = await _pointsCollection.doc('current').get();
      if (!doc.exists) {
        throw Exception('Route does not exist');
      } else {
        await _pointsCollection.doc('current').update(points.toMap());
        AppLogger.printInfo('Route Updated successfully.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error updating points details: $e');
    }
  }

  Future<void> resetPoints() async {
    try {
      await _pointsCollection.doc('current').set({
        'plasticPointsPerKg': 0.0,
        'glassPointsPerKg': 0.0,
        'paperPointsPerKg': 0.0,
        'organicPointsPerKg': 0.0,
        'metalPointsPerKg': 0.0,
        'eWastePointsPerKg': 0.0,
      });
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error resetting points details: $e');
    }
  }
}
