import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String email;
  String password;
  String userType;

  User({
    this.id = '',
    required this.email,
    required this.password,
    this.userType = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'userType': userType,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'],
      password: data['password'],
      userType: data['userType'],
    );
  }
}
