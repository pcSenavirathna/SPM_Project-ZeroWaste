import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/garbage_entry.dart';
import 'package:zero_waste/repositories/rewards_repository.dart';
import 'package:zero_waste/utils/app_logger.dart';

class GarbageEntryRepository {
  final CollectionReference _garbageEntryCollectionCollection =
      FirebaseFirestore.instance.collection('garbageEntries');

  Future<void> addEntry(GarbageEntry garbageEntry) async {
    try {
      await _garbageEntryCollectionCollection.add(garbageEntry.toMap());
      AppLogger.printInfo('Garbage entry Added successfully.');
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error adding GarbageEntry: $e');
    }
  }

  Future<void> updateEntry(String garbageId, GarbageEntry garbageEntry) async {
    try {
      final doc = await _garbageEntryCollectionCollection.doc(garbageId).get();
      if (!doc.exists) {
        AppLogger.printError('Garbage Entry does not exist: $garbageId');
        throw Exception('Garbage Entry does not exist: $garbageId');
      } else {
        await _garbageEntryCollectionCollection
            .doc(garbageId)
            .update(garbageEntry.toMap());
        AppLogger.printInfo('Garbage entry Updated successfully.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error deleting CollectionRoute: $e');
    }
  }

  Future<void> deleteEntry(String garbageId) async {
    try {
      DocumentSnapshot garbageDoc =
          await _garbageEntryCollectionCollection.doc(garbageId).get();

      if (garbageDoc.exists) {
        GarbageEntry entry = GarbageEntry.fromDocument(garbageDoc);

        await RewardsRepository()
            .reduceRewardPointsOnDelete(entry.userId, entry.totalPoints);

        await _garbageEntryCollectionCollection.doc(garbageId).delete();

        AppLogger.printInfo('Garbage entry deleted successfully.');
      } else {
        AppLogger.printError('Garbage entry not found.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error deleting GarbageEntry: $e');
    }
  }
}
