import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:http/http.dart' as http; // For sending HTTP requests
import 'dart:convert'; // For JSON encoding

class QRScanPage extends StatelessWidget {
  const QRScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/profile');
          },
        ),
      ),
      body: Container(
        color: Colors.green, // Set the background color to green
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Scan the QR Code',
                style: TextStyle(
                  fontSize: 24, // Title size
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
            ),
            Expanded(
              child: const QRViewExample(),
            ),
          ],
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? lastScannedData; // Variable to keep track of the last scanned data

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green.shade700,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 250,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // Check if the scanned data is the same as the last one
      if (scanData.code != lastScannedData) {
        lastScannedData = scanData.code; // Update the last scanned data
        print('Scanned Data: ${scanData.code}');
        _showTopUpDialog(scanData.code); // Show the top-up dialog
      }
    });
  }

  void _showTopUpDialog(String? scannedData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green, // Set the background color to green
          title: const Text(
            "Send Message",
            style: TextStyle(color: Colors.white), // Set title text color to white
          ),
          content: const Text(
            "Send the message to all users?",
            style: TextStyle(color: Colors.white), // Set content text color to white
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // Set text color to black
              ),
              child: const Text("Yes"),
              onPressed: () {
                _sendMessageToUsers(scannedData);
                Navigator.of(context).pop(); // Close the dialog
                _showAwesomeMessage(); // Show awesome message after sending
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // Set text color to black
              ),
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }



  Future<void> _sendMessageToUsers(String? url) async {
    // Reference your Firestore collection where user data is stored
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Fetch all users
    final querySnapshot = await usersCollection.get();

    // Prepare the message
    String message = 'Slim front smart bin is clear: $url';

    // Send message to all users
    for (var doc in querySnapshot.docs) {
      String userId = doc.id; // Assuming each document ID is a user ID
      String? fcmToken = doc.data()['fcm_token']; // Replace with your field name for FCM tokens
      if (fcmToken != null) {
        await _sendPushNotification(fcmToken, message); // Send the push notification
      }
      print('Sending message to $userId: $message'); // Replace with actual sending logic
    }

    // Notify the user that the message has been sent
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message sent to all users.')),
    );
  }

  Future<void> _sendPushNotification(String fcmToken, String message) async {
    final url = 'https://fcm.googleapis.com/fcm/send';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'AIzaSyAz2CGHaNBaDGCtcm7gZk3uFP29MbobIsM', // Replace with your server key
    };
    final body = jsonEncode({
      'to': fcmToken,
      'notification': {
        'title': 'Smart Bin Alert',
        'body': message,
      },
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Push notification sent successfully.');
      } else {
        print('Failed to send push notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

  void _showAwesomeMessage() {
    // Show an awesome message to all app users
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Awesome! Message sent to all users!')),
    );
  }
}
