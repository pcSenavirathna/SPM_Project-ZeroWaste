import 'package:cloud_firestore/cloud_firestore.dart';

class HouseholdUser {
  String id;
  String fName;
  String lName;
  String nic;
  String mobile;
  DateTime dob;
  String address;
  String households;
  String imageUrl;
  String userId;

  HouseholdUser(
      {required this.id,
      required this.fName,
      required this.lName,
      required this.nic,
      required this.mobile,
      required this.dob,
      required this.address,
      required this.households,
      this.imageUrl = '',
      required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fName': fName,
      'lName': lName,
      'nic': nic,
      'mobile': mobile,
      'dob': dob,
      'address': address,
      'households': households,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }

  factory HouseholdUser.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HouseholdUser(
      id: data['id'],
      fName: data['fName'],
      lName: data['lName'],
      nic: data['nic'],
      mobile: data['mobile'],
      dob: (data['dob'] as Timestamp).toDate(),
      address: data['address'],
      households: data['households'],
      imageUrl: data['imageUrl'],
      userId: data['userId'],
    );
  }
}
