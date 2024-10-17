

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SmartBinLevelPage extends StatefulWidget {
  final String binName;
  final bool isRealTime;
  final int garbageLevel;

  SmartBinLevelPage({
    required this.binName,
    required this.isRealTime,
    this.garbageLevel = 0, // Default value for fake levels
  });

  @override
  _SmartBinLevelPageState createState() => _SmartBinLevelPageState();
}

class _SmartBinLevelPageState extends State<SmartBinLevelPage> {
  int? _currentGarbageLevel;
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    if (widget.isRealTime) {
      subscribeToGarbageLevel();
    } else {
      // Use the fake garbage level passed in
      _currentGarbageLevel = widget.garbageLevel;
    }
  }

  // Subscribe to Firebase garbage level changes
  void subscribeToGarbageLevel() {
    _databaseReference
        .child('ZeroWaste')
        .child('garbage_level')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as int?;
      setState(() {
        _currentGarbageLevel = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.binName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated bin fill representation
            Container(
              width: 100,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter, // Align items to the bottom
                children: [
                  // Animated filling of the bin from bottom to top
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: (_currentGarbageLevel ?? 0).toDouble(),
                    ),
                    duration: Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Container(
                        width: 100,
                        height: value * 3, // Scale to fit the container
                        decoration: BoxDecoration(
                          color: value >= 90
                              ? Colors.red
                              : (value >= 50 ? Colors.yellow : Colors.green),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                  // Bin lid at the bottom
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 10, // Height of the lid
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  // Display the garbage level in the middle of the bin
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0, // Centered vertically
                    child: Center(
                      child: Text(
                        '${_currentGarbageLevel ?? 0}%', // Show garbage level
                        style: TextStyle(
                          fontSize: 20,
                          color: _currentGarbageLevel != null &&
                              _currentGarbageLevel! >= 50 &&
                              _currentGarbageLevel! < 90
                              ? Colors.black // Change text color to black if garbage level is yellow
                              : Colors.black, // Default text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              _currentGarbageLevel != null
                  ? 'Garbage Level: $_currentGarbageLevel%'
                  : 'Loading...',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
