import 'package:cloud_firestore/cloud_firestore.dart';

class GarbageEntry {
  final String id;
  final String userId;
  final double plasticWeight;
  final double glassWeight;
  final double paperWeight;
  final double organicWeight;
  final double metalWeight;
  final double eWasteWeight;
  final DateTime date;
  final double totalPoints;

  GarbageEntry({
    this.id = '',
    required this.userId,
    required this.plasticWeight,
    required this.glassWeight,
    required this.paperWeight,
    required this.organicWeight,
    required this.metalWeight,
    required this.eWasteWeight,
    required this.date,
    required this.totalPoints,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'plasticWeight': plasticWeight,
      'glassWeight': glassWeight,
      'paperWeight': paperWeight,
      'organicWeight': organicWeight,
      'metalWeight': metalWeight,
      'eWasteWeight': eWasteWeight,
      'date': date,
      'totalPoints': totalPoints,
    };
  }

  factory GarbageEntry.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GarbageEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      plasticWeight: data['plasticWeight']?.toDouble() ?? 0.0,
      glassWeight: data['glassWeight']?.toDouble() ?? 0.0,
      paperWeight: data['paperWeight']?.toDouble() ?? 0.0,
      organicWeight: data['organicWeight']?.toDouble() ?? 0.0,
      metalWeight: data['metalWeight']?.toDouble() ?? 0.0,
      eWasteWeight: data['eWasteWeight']?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp).toDate(),
      totalPoints: data['totalPoints']?.toDouble() ?? 0.0,
    );
  }
}
