import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/waste_bin.dart';
import 'package:zero_waste/utils/app_logger.dart';

class WasteBinRepository {
  final CollectionReference _binCollection =
      FirebaseFirestore.instance.collection('wastebin');

  Future<void> addBin(WasteBin wasteBin) async {
    try {
      await _binCollection.add(wasteBin.toMap());
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error adding WasteBin: $e');
    }
  }

  Future<void> updateBin(WasteBin wasteBin) async {
    try {
      final doc = await _binCollection.doc(wasteBin.id).get();
      if (!doc.exists) {
        throw Exception('wasteBin does not exist: ${wasteBin.id}');
      } else {
        await _binCollection.doc(wasteBin.id).update(wasteBin.toMap());
        AppLogger.printInfo('wasteBin Updated successfully.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error updating WasteBin: $e');
    }
  }

  Future<void> deleteBin(String binId) async {
    try {
      final doc = await _binCollection.doc(binId).get();
      if (!doc.exists) {
        throw Exception('wasteBin does not exist: $binId');
      } else {
        await _binCollection.doc(binId).delete();
        AppLogger.printInfo('wasteBin Updated successfully.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error deleting WasteBin: $e');
    }
  }

  Future<List<WasteBin>> getAllBins() async {
    try {
      QuerySnapshot snapshot = await _binCollection.get();
      return snapshot.docs.map((doc) => WasteBin.fromDocument(doc)).toList();
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting all WasteBins: $e');
    }
  }

  Future<WasteBin> getBin(String binId) async {
    try {
      DocumentSnapshot snapshot = await _binCollection.doc(binId).get();
      if (snapshot.exists) {
        return WasteBin.fromDocument(snapshot);
      } else {
        AppLogger.printError('WasteBin not found');
        throw Exception('WasteBin not found');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting WasteBin: $e');
    }
  }

  Future<List<WasteBin>> getBinByRouteId(String routeId) async {
    try {
      final schedules =
          await _binCollection.where('routeId', isEqualTo: routeId).get();

      return schedules.docs.map((doc) => WasteBin.fromDocument(doc)).toList();
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting WasteBin: $e');
    }
  }
}
