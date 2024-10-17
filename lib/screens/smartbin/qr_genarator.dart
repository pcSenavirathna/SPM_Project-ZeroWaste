import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart'; // Import for file saving
import 'dart:io'; // Import for file operations
import 'dart:typed_data'; // Import for Uint8List
import 'package:flutter/rendering.dart'; // Import for RenderRepaintBoundary
import 'package:flutter/services.dart'; // Import for ImageByteFormat
import 'package:image_gallery_saver/image_gallery_saver.dart'; // Import for saving to gallery
import 'package:permission_handler/permission_handler.dart'; // Import for permission handling

class QrGenerate extends StatefulWidget {
  const QrGenerate({super.key});

  @override
  State<QrGenerate> createState() => _QrGenerateState();
}

class _QrGenerateState extends State<QrGenerate> {
  final GlobalKey globalKey = GlobalKey();
  String qrData = "";

  Future<void> _downloadQRCode() async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        // Capture the QR code as an image
        RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
        final Uint8List pngBytes = byteData!.buffer.asUint8List();

        // Save the image to the gallery
        final result = await ImageGallerySaver.saveImage(pngBytes, name: 'qr_code');

        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('QR Code downloaded to gallery!')),
          );
        } else {
          throw Exception('Error saving QR Code to gallery');
        }
      } catch (e) {
        // Handle exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied. Please enable storage permission.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Generator"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/profile');
          },
        ),
      ),
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            RepaintBoundary(
              key: globalKey,
              child: Container(
                color: Colors.white, // Set the background color to white
                padding: const EdgeInsets.all(16), // Optional: Add padding around QR code
                child: Center(
                  child: qrData.isEmpty
                      ? const Text(
                    "Enter Data To Generate QR Code",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.05, // 10% border radius
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter Location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.1, // 10% border radius for the TextField border
                    ),
                    borderSide: BorderSide.none, // Removes the border outline of the TextField
                  ),
                  filled: true, // Enables the background color for the TextField
                  fillColor: Colors.white, // Ensures the background inside the TextField is white
                ),
                onChanged: (value) {
                  setState(() {
                    qrData = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (qrData.isNotEmpty) {
                  _downloadQRCode();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter data first.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
              ),
              child: const Text('Download QR Code'),
            )

          ],
        ),
      ),
    );
  }
}
