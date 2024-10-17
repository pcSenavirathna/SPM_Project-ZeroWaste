import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/screens/home_screen.dart';
import 'add_smart_bin.dart';
import 'smartbin_level.dart';

class GarbageLevelPage extends StatefulWidget {
  const GarbageLevelPage({super.key});

  @override
  _GarbageLevelPageState createState() => _GarbageLevelPageState();
}

class _GarbageLevelPageState extends State<GarbageLevelPage> {
  List<String> smartBins = [
    'Kaduwela Smart Bin',
    'Malabe Smart Bin',
    'Pittugala Smart Bin',
    'Sliit Smart Bin',
  ];

  // Sample fake garbage levels for the bins
  List<int> fakeGarbageLevels = [
    78,
    43,
    22
  ]; // Levels for Kaduwela, Malabe, Pittugala

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garbage Level'),
        backgroundColor: Colors.green, // Set the header color to green
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/profile');
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Number of columns
                padding: const EdgeInsets.all(20),
                childAspectRatio: 1, // Make buttons square
                children: List.generate(smartBins.length, (index) {
                  return SquareButton(
                    label: smartBins[index],
                    onPressed: () {
                      // Pass 0 for newly added bins, or the appropriate fake level
                      int garbageLevel = index < fakeGarbageLevels.length
                          ? fakeGarbageLevels[index]
                          : 0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SmartBinLevelPage(
                            binName: smartBins[index],
                            isRealTime: index == 3, // Only Sliit uses real-time data
                            garbageLevel: garbageLevel, // Use the appropriate garbage level
                          ),
                        ),
                      );
                    },
                    color: Colors.green, // Set all buttons to green
                  );
                }),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to AddSmartBinPage and handle new smart bin addition
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSmartBinPage(
                      onAdd: (newBin) {
                        setState(() {
                          smartBins.add('$newBin Smart Bin'); // Add new bin to the list
                          fakeGarbageLevels.add(0); // Add initial level as 0 for new bins
                        });
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text(
                'Add New Smart Bin',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20), // Add some space below the button
          ],
        ),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color; // Added color parameter

  const SquareButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color, // Accept color as parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10), // Margin around the button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Use the passed color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          padding: const EdgeInsets.all(20), // Padding inside the button
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ), // Button text style
        ),
      ),
    );
  }
}
