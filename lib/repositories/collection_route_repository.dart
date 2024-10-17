import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/collection_route.dart';
import 'package:zero_waste/utils/app_logger.dart';

class CollectionRouteRepository {
  final CollectionReference _routeCollection =
      FirebaseFirestore.instance.collection('route');

  Future<String> generateRouteId() async {
    try {
      QuerySnapshot snapshot = await _routeCollection.get();
      int count = snapshot.size;
      if (count == 0) {
        return 'R0001';
      } else {
        count++;
        String userId = 'R${count.toString().padLeft(4, '0')}';
        return userId;
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error generating unique Route ID: $e');
    }
  }

  Future<void> addRoute(CollectionRoute collectionRoute) async {
    try {
      collectionRoute.id = await generateRouteId();
      await _routeCollection
          .doc(collectionRoute.id)
          .set(collectionRoute.toMap());
      AppLogger.printInfo('Route Added successfully.');
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error adding CollectionRoute: $e');
    }
  }

  Future<void> updateRoute(CollectionRoute collectionRoute) async {
    try {
      final doc = await _routeCollection.doc(collectionRoute.id).get();
      if (!doc.exists) {
        throw Exception('Route does not exist: ${collectionRoute.id}');
      } else {
        await _routeCollection
            .doc(collectionRoute.id)
            .update(collectionRoute.toMap());
        AppLogger.printInfo('Route Updated successfully.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error updating Collection Route: $e');
    }
  }

  Future<void> deleteRoute(String routeId) async {
    try {
      final doc = await _routeCollection.doc(routeId).get();
      if (!doc.exists) {
        throw Exception('Route does not exist: $routeId');
      } else {
        await _routeCollection.doc(routeId).delete();
        AppLogger.printInfo('Route Deleted successfully.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error deleting CollectionRoute: $e');
    }
  }

  Future<List<CollectionRoute>> getAllRoutes() async {
    try {
      QuerySnapshot snapshot = await _routeCollection.get();
      return snapshot.docs
          .map((doc) => CollectionRoute.fromDocument(doc))
          .toList();
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting all CollectionRoute: $e');
    }
  }

  Future<CollectionRoute> getRoute(String routeId) async {
    try {
      DocumentSnapshot snapshot = await _routeCollection.doc(routeId).get();
      if (snapshot.exists) {
        return CollectionRoute.fromDocument(snapshot);
      } else {
        AppLogger.printError('Collection Route not found');
        throw Exception('Collection Route not found');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting CollectionRoute: $e');
    }
  }
}
