import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/employee.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/repositories/user_repository.dart';
import 'package:zero_waste/utils/app_logger.dart';

class EmployeeRepository {
  final CollectionReference _employeeCollection =
      FirebaseFirestore.instance.collection('employee');

  Future<String> generateUniqueId() async {
    try {
      QuerySnapshot snapshot = await _employeeCollection.get();
      int count = snapshot.size;
      if (count == 0) {
        return 'E0001';
      } else {
        count++;
        String userId = 'E${count.toString().padLeft(4, '0')}';
        return userId;
      }
    } catch (e) {
      throw Exception('Error generating unique Employee ID: $e');
    }
  }

  Future<void> addEmployee(User user, Employee employee) async {
    try {
      DocumentReference userId = await UserRepository().addUser(user);
      employee.userId = userId.id;
      employee.id = await generateUniqueId();
      await _employeeCollection.doc(employee.id).set(employee.toMap());
      AppLogger.printInfo('Employee Added successfully.');
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error adding Employee: $e');
    }
  }

  Future<void> updateEmployee(String userId, Employee employee) async {
    try {
      final doc = await _employeeCollection.doc(userId).get();
      if (!doc.exists) {
        AppLogger.printError('Employee does not exist: $userId');
        throw Exception('Employee does not exist: $userId');
      } else {
        await _employeeCollection.doc(userId).update(employee.toMap());
        AppLogger.printInfo('Employee Updated successfully.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error updating Employee: $e');
    }
  }

  Future<void> deleteEmployee(String userId) async {
    try {
      final doc = await _employeeCollection.doc(userId).get();
      if (!doc.exists) {
        AppLogger.printError('Employee does not exist: $userId');
        throw Exception('Employee does not exist: $userId');
      } else {
        await _employeeCollection.doc(userId).delete();
        AppLogger.printInfo('Employee Deleted successfully.');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error deleting Employee: $e');
    }
  }

  Future<List<Employee>> getAllEmployees() async {
    try {
      QuerySnapshot snapshot = await _employeeCollection.get();
      return snapshot.docs.map((doc) => Employee.fromDocument(doc)).toList();
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting all Employee: $e');
    }
  }

  Future<Employee> getEmployee(String userId) async {
    try {
      DocumentSnapshot snapshot = await _employeeCollection.doc(userId).get();
      if (snapshot.exists) {
        return Employee.fromDocument(snapshot);
      } else {
        throw Exception('Employee not found');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting Employee: $e');
    }
  }

  Future<Employee?> getEmployeeByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await _employeeCollection.where('userId', isEqualTo: userId).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return Employee.fromDocument(doc);
      } else {
        AppLogger.printError('Employee not found with Id $userId');
        throw Exception('Employee not found with Id $userId');
      }
    } catch (e) {
      AppLogger.printError(e.toString());
      throw Exception('Error getting Employee by email: $e');
    }
  }
}
