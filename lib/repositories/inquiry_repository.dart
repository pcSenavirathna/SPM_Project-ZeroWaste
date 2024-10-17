import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/inquiry.dart';

class InquiryRepository {
  final CollectionReference _inquiryCollection = FirebaseFirestore.instance.collection('inquiries');

  //Add inquiry
   Future<void> createInquiry(Inquiry inquiry) async {
    try {
      await _inquiryCollection.add(inquiry.toMap());
    } catch (e) {
      throw Exception('Error sending inquiry to garbage assistant: $e');
    }
  }

  //deleting inquiry
  Future<void> deleteInquiry(String inquiryID) async {
    try {
      await _inquiryCollection.doc(inquiryID).delete();
    } catch (e) {
      throw Exception('Trouble deleting inquiry: $e');
    }
  }

  // Retrieve inquiry by docId
  Future<Inquiry> getInquiry(String docId) async {
    try {
      DocumentSnapshot snapshot = await _inquiryCollection.doc(docId).get();
      if (snapshot.exists) {
        return Inquiry.fromDocument(snapshot);
      } else {
        throw Exception('Inquiry Not found');
      }
    } catch (e) {
      throw Exception('Error retrieving inquiry: $e');
    }
  }

  // Update inquiry
  Future<void> updateInquiry(String docId, Inquiry inquiry) async {
    try {
      await _inquiryCollection.doc(docId).update(inquiry.toMap());
    } catch (e) {
      throw Exception('Error updating inquiry: $e');
    }
  }
}