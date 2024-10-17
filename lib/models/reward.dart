import 'package:cloud_firestore/cloud_firestore.dart';

class Reward {
  final String userId;
  final int points;

  Reward({
    required this.userId,
    required this.points,
  });

  factory Reward.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reward(
      userId: data['userId'] ?? '',
      points: data['points'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'points': points,
    };
  }
}
