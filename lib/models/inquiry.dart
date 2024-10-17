import 'package:cloud_firestore/cloud_firestore.dart';

class Inquiry{
  String inquiryID;
  String email;
  String personName;
  String? smartbinID;
  String? inquiryType; //normal
  int? daysDelayed;  //garbage
  String? overflowingBinID;  //garbage
  String? wasteLocation; //garbage
  String? wastetype;  //Bulky or e-waste
  DateTime? desiredPickupDate; // Bulky or e-waste 
  String? inquiryDescription; //normal
  String? desiredSolution; //normal
  DateTime inquiryDate; //normal

  Inquiry({
    this.inquiryID = '',
    this.email = '',
    this.personName = '',
    this.smartbinID,
    this.inquiryType,
    this.daysDelayed,
    this.overflowingBinID,
    this.wasteLocation,
    this.wastetype,
    required this.desiredPickupDate,
    this.inquiryDescription,
    this.desiredSolution,
    required this.inquiryDate,
  });

  Map<String, dynamic> toMap(){
    return {
      'inquiryID': inquiryID,
      'email': email,
      'personName': personName,
      'smartbinID': smartbinID,
      'inquiryType': inquiryType,
      'daysDelayed': daysDelayed,
      'overflowingBinID': overflowingBinID,
      'wasteLocation': wasteLocation,
      'wastetype': wastetype,
      'desiredPickupDate': desiredPickupDate,
      'inquiryDescription': inquiryDescription,
      'desiredSolution': desiredSolution,
      'inquiryDate': inquiryDate
    };
  }

  factory Inquiry.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Inquiry(
      inquiryID: data['inquiryID']  ?? '',
      email: data['email']  ?? '',
      personName: data['personName']  ?? '',
      smartbinID: data['smartbinID']?? '',
      inquiryType: data['inquiryType'] ?? '',
      daysDelayed: data['daysDelayed'] ?? '',
      overflowingBinID: data['overflowingBinID'] ?? '',
      wasteLocation: data['wasteLocation'] ?? '',
      wastetype: data['wastetype'] ?? '',
      desiredPickupDate: (data['desiredPickupDate'] != null) 
          ? (data['desiredPickupDate'] as Timestamp).toDate() 
          : null,
      inquiryDescription: data['inquiryDescription'] ?? '',
      desiredSolution: data['desiredSolution'] ?? '',
      inquiryDate: (data['inquiryDate'] as Timestamp).toDate(),
    );
  }
}

