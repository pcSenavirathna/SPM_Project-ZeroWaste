import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String id;
  String fName;
  String lName;
  String nic;
  String mobile;
  DateTime dob;
  String address;
  String imageUrl;
  String employeeType;
  String userId;

  Employee(
      {required this.id,
        required this.fName,
        required this.lName,
        required this.nic,
        required this.mobile,
        required this.dob,
        required this.address,
        this.imageUrl = '',
        required this.employeeType,
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
      'imageUrl': imageUrl,
      'employeeType': employeeType,
      'userId': userId,
    };
  }

  factory Employee.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Employee(
      id: data['id'],
      fName: data['fName'],
      lName: data['lName'],
      nic: data['nic'],
      mobile: data['mobile'],
      dob: (data['dob'] as Timestamp).toDate(),
      address: data['address'],
      imageUrl: data['imageUrl'],
      employeeType: data['employeeType'],
      userId: data['userId'],
    );
  }
}
