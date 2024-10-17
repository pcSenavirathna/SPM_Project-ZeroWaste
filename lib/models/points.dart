import 'package:cloud_firestore/cloud_firestore.dart';

class Points {
  final double plasticPointsPerKg;
  final double glassPointsPerKg;
  final double paperPointsPerKg;
  final double organicPointsPerKg;
  final double metalPointsPerKg;
  final double eWastePointsPerKg;

  Points({
    required this.plasticPointsPerKg,
    required this.glassPointsPerKg,
    required this.paperPointsPerKg,
    required this.organicPointsPerKg,
    required this.metalPointsPerKg,
    required this.eWastePointsPerKg,
  });

  factory Points.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Points(
      plasticPointsPerKg: data['plasticPointsPerKg'] ?? 0.0,
      glassPointsPerKg: data['glassPointsPerKg'] ?? 0.0,
      paperPointsPerKg: data['paperPointsPerKg'] ?? 0.0,
      organicPointsPerKg: data['organicPointsPerKg'] ?? 0.0,
      metalPointsPerKg: data['metalPointsPerKg'] ?? 0.0,
      eWastePointsPerKg: data['eWastePointsPerKg'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plasticPointsPerKg': plasticPointsPerKg,
      'glassPointsPerKg': glassPointsPerKg,
      'paperPointsPerKg': paperPointsPerKg,
      'organicPointsPerKg': organicPointsPerKg,
      'metalPointsPerKg': metalPointsPerKg,
      'eWastePointsPerKg': eWastePointsPerKg,
    };
  }
}
