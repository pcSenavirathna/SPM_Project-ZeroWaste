import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:awesome_notifications/awesome_notifications.dart'; // For triggering notifications

class NotificationListener extends StatefulWidget {
  @override
  _NotificationListenerState createState() => _NotificationListenerState();
}

class _NotificationListenerState extends State<NotificationListener> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('ZeroWaste');
  String? alertMessage;

  @override
  void initState() {
    super.initState();
    _setupListener();
    _initializeNotifications(); // Initialize Awesome Notifications
  }

  void _initializeNotifications() {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon', // Your app icon (replace with actual icon)
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
    );
  }

  void _setupListener() {
    _databaseRef.child('alert_message').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is String) {
        setState(() {
          alertMessage = data;
          _showNotification(data); // Show the notification
        });
      }
    });
  }

  // Function to trigger Awesome Notification
  void _showNotification(String message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'New Alert',
        body: message,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  // Function to launch the URL in the default browser
  Future<void> _launchURL() async {
    String url = 'https://ift.tt/vJNe5wa'; // Test with a known working URL

    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }


  // Function to delete the alert_message from Firebase
  Future<void> _deleteAlertMessage() async {
    await _databaseRef.child('alert_message').remove();
    setState(() {
      alertMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Listener'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (alertMessage != null) ...[
            Dismissible(
              key: Key(alertMessage!), // Unique key for each card
              background: Container(
                color: Colors.red, // Left swipe color (delete)
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.blue, // Right swipe color (open URL)
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16.0),
                child: const Icon(Icons.map, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  // Left swipe (delete alert_message)
                  await _deleteAlertMessage();
                  return true; // Allow dismissal after delete
                }
                return false;
              },
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.green, // Set card color to green
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alertMessage!,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white), // White text color
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _launchURL(); // Replace with actual coordinates
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White background
                            foregroundColor: Colors.black, // Black text color
                          ),
                          child: const Text('View'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Waiting for alerts...",
                style: TextStyle(fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }
}
