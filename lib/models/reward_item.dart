import 'package:cloud_firestore/cloud_firestore.dart';

class RewardItem {
  String id;
  String name;
  int points;
  String image;
  String description;

  RewardItem({
    required this.id,
    required this.name,
    required this.points,
    required this.image,
    required this.description,
  });

  factory RewardItem.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RewardItem(
      id: doc.id,
      name: data['name'],
      points: data['points'],
      image: data['image'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'points': points,
      'image': image,
      'description': description,
    };
  }
}
