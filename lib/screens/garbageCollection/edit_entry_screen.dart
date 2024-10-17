import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/garbage_entry.dart';
import 'package:zero_waste/models/points.dart';
import 'package:zero_waste/repositories/garbage_entry_repository.dart';
import 'package:zero_waste/repositories/points_repository.dart';
import 'package:zero_waste/repositories/rewards_repository.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';
import 'package:zero_waste/widgets/submit_button.dart';

class EditEntryScreen extends StatefulWidget {
  final GarbageEntry entry;

  const EditEntryScreen({super.key, required this.entry});

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  late TextEditingController plasticController;
  late TextEditingController glassController;
  late TextEditingController paperController;
  late TextEditingController organicController;
  late TextEditingController metalController;
  late TextEditingController ewasteController;

  @override
  void initState() {
    super.initState();
    plasticController =
        TextEditingController(text: widget.entry.plasticWeight.toString());
    glassController =
        TextEditingController(text: widget.entry.glassWeight.toString());
    paperController =
        TextEditingController(text: widget.entry.paperWeight.toString());
    organicController =
        TextEditingController(text: widget.entry.organicWeight.toString());
    metalController =
        TextEditingController(text: widget.entry.metalWeight.toString());
    ewasteController =
        TextEditingController(text: widget.entry.eWasteWeight.toString());
  }

  @override
  void dispose() {
    plasticController.dispose();
    glassController.dispose();
    paperController.dispose();
    organicController.dispose();
    metalController.dispose();
    ewasteController.dispose();
    super.dispose();
  }

  Future<double> _calculatePoints() async {
    final PointsRepository pointsRepository = PointsRepository();
    Points? points;
    try {
      points = await pointsRepository.getPointDetails();
    } catch (e) {
      print('Error fetching point details: $e');
      return 0.0;
    }

    if (points == null) {
      return 0.0;
    }

    double plasticPoints = (double.tryParse(plasticController.text) ?? 0) *
        points.plasticPointsPerKg;
    double glassPoints =
        (double.tryParse(glassController.text) ?? 0) * points.glassPointsPerKg;
    double paperPoints =
        (double.tryParse(paperController.text) ?? 0) * points.paperPointsPerKg;
    double organicPoints = (double.tryParse(organicController.text) ?? 0) *
        points.organicPointsPerKg;
    double metalPoints =
        (double.tryParse(metalController.text) ?? 0) * points.metalPointsPerKg;
    double eWastePoints = (double.tryParse(ewasteController.text) ?? 0) *
        points.eWastePointsPerKg;

    return plasticPoints +
        glassPoints +
        paperPoints +
        organicPoints +
        metalPoints +
        eWastePoints;
  }

  Future<void> _updateEntry(BuildContext context) async {
    double plasticWeight = double.tryParse(plasticController.text) ?? 0;
    double glassWeight = double.tryParse(glassController.text) ?? 0;
    double paperWeight = double.tryParse(paperController.text) ?? 0;
    double organicWeight = double.tryParse(organicController.text) ?? 0;
    double metalWeight = double.tryParse(metalController.text) ?? 0;
    double ewasteWeight = double.tryParse(ewasteController.text) ?? 0;

    if (plasticWeight < 0 ||
        glassWeight < 0 ||
        paperWeight < 0 ||
        organicWeight < 0 ||
        metalWeight < 0 ||
        ewasteWeight < 0) {
      okMessageDialog(context, "Error!",
          'Please enter non-negative values for all weights.');
      return;
    }

    double previousPoints = widget.entry.totalPoints;
    double newTotalPoints = await _calculatePoints();

    final garbageEntry = GarbageEntry(
        userId: widget.entry.userId,
        plasticWeight: plasticWeight,
        glassWeight: glassWeight,
        paperWeight: paperWeight,
        organicWeight: organicWeight,
        metalWeight: metalWeight,
        eWasteWeight: ewasteWeight,
        date: widget.entry.date,
        totalPoints: newTotalPoints);

    GarbageEntryRepository()
        .updateEntry(widget.entry.id, garbageEntry)
        .then((_) async {
      bottomMessage(context, 'Entry updated successfully!');

      await RewardsRepository().updateRewardPointsBasedOnGarbageEntry(
          widget.entry.userId, previousPoints, newTotalPoints);

      Future.delayed(const Duration(seconds: 2), () {
        context.go("/collection/history");
      });
    }).catchError((error) {
      okMessageDialog(context, "Error!", 'Failed to update entry: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Entry'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildWasteCard(
                  'Plastic Weight', plasticController, Icons.local_drink),
              _buildWasteCard('Glass Weight', glassController, Icons.wine_bar),
              _buildWasteCard('Paper Weight', paperController, Icons.article),
              _buildWasteCard('Organic Weight', organicController, Icons.grass),
              _buildWasteCard(
                  'Metal Weight', metalController, Icons.home_repair_service),
              _buildWasteCard('E-Waste Weight', ewasteController, Icons.memory),
              const SizedBox(height: 20),
              SubmitButton(
                  icon: Icons.send, text: "Save", whenPressed: _updateEntry),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWasteCard(
      String label, TextEditingController controller, IconData icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.green.shade600),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.green.shade600, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
