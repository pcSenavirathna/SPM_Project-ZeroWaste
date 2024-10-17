import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/reward.dart';
import 'package:zero_waste/utils/app_logger.dart';

class RewardsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _rewardsCollection =
      FirebaseFirestore.instance.collection('rewards');

  Future<void> updateRewardsForUser(String userId, double pointsToAdd) async {
    try {
      DocumentSnapshot rewardDoc = await _rewardsCollection.doc(userId).get();

      if (rewardDoc.exists) {
        Reward existingReward = Reward.fromDocument(rewardDoc);
        int updatedPoints = existingReward.points + pointsToAdd.round();
        await _rewardsCollection.doc(userId).update({'points': updatedPoints});
      } else {
        Reward newReward = Reward(userId: userId, points: pointsToAdd.round());
        await _rewardsCollection.doc(userId).set(newReward.toMap());
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error updating rewards: $e');
    }
  }

  Future<void> updateRewardPointsBasedOnGarbageEntry(
      String userId, double previousPoints, double newPoints) async {
    try {
      DocumentSnapshot rewardDoc = await _rewardsCollection.doc(userId).get();

      if (rewardDoc.exists) {
        Reward existingReward = Reward.fromDocument(rewardDoc);
        int currentRewardPoints = existingReward.points;
        int pointsDifference = (newPoints - previousPoints).round();

        if (pointsDifference != 0) {
          int updatedPoints = currentRewardPoints + pointsDifference;

          if (updatedPoints < 0) updatedPoints = 0;

          await _rewardsCollection.doc(userId).update({
            'points': updatedPoints,
          });

          AppLogger.printInfo('Reward points updated: $updatedPoints');
        } else {
          AppLogger.printInfo('No change in reward points.');
        }
      } else {
        await _rewardsCollection.doc(userId).set({
          'points': newPoints.round(),
        });

        AppLogger.printInfo(
            'New reward created with points: ${newPoints.round()}');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error updating reward points: $e');
    }
  }

  Future<void> reduceRewardPointsOnDelete(
      String userId, double deletedPoints) async {
    try {
      DocumentSnapshot rewardDoc = await _rewardsCollection.doc(userId).get();

      if (rewardDoc.exists) {
        Reward existingReward = Reward.fromDocument(rewardDoc);
        int currentRewardPoints = existingReward.points;

        int updatedPoints = currentRewardPoints - deletedPoints.round();

        if (updatedPoints > 0) {
          await _rewardsCollection.doc(userId).update({
            'points': updatedPoints,
          });
          AppLogger.printInfo('Reward points reduced: $updatedPoints');
        } else {
          await _rewardsCollection.doc(userId).delete();
          AppLogger.printInfo('Reward deleted due to zero points.');
        }
      } else {
        AppLogger.printError('No reward found for user.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error reducing reward points: $e');
    }
  }

  Future<bool> buyItem(String userId, int itemPoints) async {
    try {
      return await _firestore.runTransaction((transaction) async {
        DocumentReference rewardRef =
            _firestore.collection('rewards').doc(userId);
        DocumentSnapshot rewardDoc = await transaction.get(rewardRef);

        if (!rewardDoc.exists) {
          return false;
        }

        Reward reward = Reward.fromDocument(rewardDoc);

        if (reward.points < itemPoints) {
          return false;
        }

        int newPoints = reward.points - itemPoints;
        transaction.update(rewardRef, {'points': newPoints});

        return true;
      });
    } catch (e) {
      AppLogger.printError(e.toString());
      return false;
    }
  }

  Stream<Reward> getRewardStream(String userId) {
    return _firestore
        .collection('rewards')
        .doc(userId)
        .snapshots()
        .map((snapshot) => Reward.fromDocument(snapshot));
  }
}
