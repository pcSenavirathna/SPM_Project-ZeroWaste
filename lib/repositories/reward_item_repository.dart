import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/reward_item.dart';
import 'package:zero_waste/utils/app_logger.dart';

class RewardItemRepository {
  final CollectionReference _rewardItemsCollection =
      FirebaseFirestore.instance.collection('reward_items');

  Future<void> addItem(RewardItem item) async {
    try {
      await _rewardItemsCollection.doc(item.id).set(item.toMap());
      AppLogger.printInfo('RewardItem Added successfully.');
    } catch (error) {
      AppLogger.printError(error.toString());
      throw Exception("Error Adding Reward Items : $error");
    }
  }

  Future<void> updateItem(RewardItem item) async {
    try {
      final doc = await _rewardItemsCollection.doc(item.id).get();
      if (!doc.exists) {
        throw Exception('RewardItem does not exist: ${item.id}');
      } else {
        await _rewardItemsCollection.doc(item.id).update(item.toMap());
        AppLogger.printInfo('RewardItem Updated successfully.');
      }
    } catch (error) {
      AppLogger.printError(error.toString());
      throw Exception("Error Updating Reward Items : $error");
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      final doc = await _rewardItemsCollection.doc(id).get();
      if (!doc.exists) {
        throw Exception('RewardItem does not exist: $id');
      } else {
        await _rewardItemsCollection.doc(id).delete();
        AppLogger.printInfo('RewardItem Updated successfully.');
      }
    } catch (error) {
      AppLogger.printError(error.toString());
      throw Exception("Error Deleting Reward Items : $error");
    }
  }

  Stream<List<RewardItem>> getItems() {
    try {
      return _rewardItemsCollection.snapshots().map(
        (snapshot) {
          return snapshot.docs
              .map(
                (doc) => RewardItem.fromDocument(doc),
              )
              .toList();
        },
      );
    } catch (error) {
      AppLogger.printError(error.toString());
      throw Exception("Error Getting Reward Items : $error");
    }
  }
}
