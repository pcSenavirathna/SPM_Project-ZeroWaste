import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/utils/app_logger.dart';
import '../models/user.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<DocumentReference<Object?>> addUser(User user) async {
    try {
      DocumentReference userRef = await _usersCollection.add(user.toMap());
      return userRef;
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error adding user: $e');
    }
  }

  Future<void> updateUser(String userId, User user) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) {
        throw Exception('User does not exist: $userId');
      } else {
        await _usersCollection.doc(userId).update(user.toMap());
        AppLogger.printInfo('User Updated successfully.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error updating user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) {
        throw Exception('User does not exist: $userId');
      } else {
        await _usersCollection.doc(userId).delete();
        AppLogger.printInfo('User Deleted successfully.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error deleting user: $e');
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _usersCollection.get();
      return snapshot.docs.map((doc) => User.fromDocument(doc)).toList();
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting all users: $e');
    }
  }

  Future<User> getUser(String userId) async {
    try {
      DocumentSnapshot snapshot = await _usersCollection.doc(userId).get();
      if (snapshot.exists) {
        return User.fromDocument(snapshot);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting user: $e');
    }
  }

  Future<User> login(User user) async {
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection.where('email', isEqualTo: user.email).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        if (documentSnapshot.get('password') == user.password) {
          return User.fromDocument(documentSnapshot);
        } else {
          AppLogger.printError('Invalid password');
          throw Exception('Invalid password');
        }
      } else {
        AppLogger.printError('User not found');
        throw Exception('User not found');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting user: $e');
    }
  }
}
