import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  // Method to get garbage level
  Future<int?> getGarbageLevel() async {
    try {
      DatabaseEvent event = await _databaseReference
          .child('ZeroWaste')
          .child('garbage_level')
          .once();
      DataSnapshot snapshot = event.snapshot;

      // Check if the snapshot contains an int value
      return snapshot.value is int ? snapshot.value as int : null;
    } catch (error) {
      // Consider using a logging package or error handling strategy
      print('Error retrieving garbage level: $error');
      return null;
    }
  }
  // Method to get real-time updates
  late final StreamSubscription<DatabaseEvent> _subscription;

  void subscribeToGarbageLevel(Function(int?) callback) {
    _subscription = _databaseReference
        .child('ZeroWaste')
        .child('garbage_level')
        .onValue
        .listen((event) {
      final data = event.snapshot.value is int ? event.snapshot.value as int : null;
      callback(data);
    });
  }

  // Method to dispose of the subscription
  void dispose() {
    _subscription.cancel();
  }
}
