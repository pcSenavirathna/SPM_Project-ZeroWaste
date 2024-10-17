import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zero_waste/models/garbage_entry.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:zero_waste/models/points.dart';
import 'package:zero_waste/repositories/garbage_entry_repository.dart';
import 'package:zero_waste/repositories/points_repository.dart';
import 'package:zero_waste/repositories/rewards_repository.dart';
import 'package:zero_waste/utils/validators.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';
import 'package:zero_waste/widgets/submit_button.dart';
import 'package:zero_waste/widgets/text_field_input.dart';

class RecordGarbageEntryScreen extends StatefulWidget {
  const RecordGarbageEntryScreen({super.key});

  @override
  State<RecordGarbageEntryScreen> createState() =>
      _RecordGarbageEntryScreenState();
}

class _RecordGarbageEntryScreenState extends State<RecordGarbageEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userId = TextEditingController();
  final _plasticWeight = TextEditingController();
  final _glassWeight = TextEditingController();
  final _paperWeight = TextEditingController();
  final _organicWeight = TextEditingController();
  final _metalWeight = TextEditingController();
  final _eWasteWeight = TextEditingController();
  double _totalPoints = 0.0;

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

    double plasticPoints =
        (double.tryParse(_plasticWeight.text) ?? 0) * points.plasticPointsPerKg;
    double glassPoints =
        (double.tryParse(_glassWeight.text) ?? 0) * points.glassPointsPerKg;
    double paperPoints =
        (double.tryParse(_paperWeight.text) ?? 0) * points.paperPointsPerKg;
    double organicPoints =
        (double.tryParse(_organicWeight.text) ?? 0) * points.organicPointsPerKg;
    double metalPoints =
        (double.tryParse(_metalWeight.text) ?? 0) * points.metalPointsPerKg;
    double eWastePoints =
        (double.tryParse(_eWasteWeight.text) ?? 0) * points.eWastePointsPerKg;

    return plasticPoints +
        glassPoints +
        paperPoints +
        organicPoints +
        metalPoints +
        eWastePoints;
  }

  void _submitEntry(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if ((double.tryParse(_plasticWeight.text) ?? 0) +
              (double.tryParse(_glassWeight.text) ?? 0) +
              (double.tryParse(_paperWeight.text) ?? 0) +
              (double.tryParse(_organicWeight.text) ?? 0) +
              (double.tryParse(_metalWeight.text) ?? 0) +
              (double.tryParse(_eWasteWeight.text) ?? 0) ==
          0) {
        okMessageDialog(
            context, "Error!", 'Please enter at least one waste weight');
        return;
      }

      _totalPoints = await _calculatePoints();

      GarbageEntry entry = GarbageEntry(
        userId: _userId.text,
        plasticWeight: double.tryParse(_plasticWeight.text) ?? 0.0,
        glassWeight: double.tryParse(_glassWeight.text) ?? 0.0,
        paperWeight: double.tryParse(_paperWeight.text) ?? 0.0,
        organicWeight: double.tryParse(_organicWeight.text) ?? 0.0,
        metalWeight: double.tryParse(_metalWeight.text) ?? 0.0,
        eWasteWeight: double.tryParse(_eWasteWeight.text) ?? 0.0,
        date: DateTime.now(),
        totalPoints: _totalPoints,
      );

      await GarbageEntryRepository().addEntry(entry);
      await RewardsRepository()
          .updateRewardsForUser(entry.userId, _totalPoints);

      await _generateAndDownloadPDF(entry);
      bottomMessage(
          context, 'Garbage entry recorded! You earned $_totalPoints points!');
    }
  }

  Future<void> _generateAndDownloadPDF(GarbageEntry entry) async {
    final pdf = pw.Document();

    final ByteData logoData = await rootBundle.load('assets/logo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    pw.TableRow buildTableRow(String label, String value) {
      return pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green800,
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(value),
          ),
        ],
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green50,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Garbage Entry Summary',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                    pw.Image(
                      pw.MemoryImage(logoBytes),
                      height: 80,
                      width: 80,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Details:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(
                thickness: 2,
                color: PdfColors.green700,
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(width: 2, color: PdfColors.green300),
                columnWidths: {
                  0: const pw.FractionColumnWidth(0.5),
                  1: const pw.FractionColumnWidth(0.5),
                },
                children: [
                  buildTableRow('User ID:', entry.userId),
                  buildTableRow('Date:', entry.date.toString()),
                  buildTableRow('Plastic Weight:', '${entry.plasticWeight} kg'),
                  buildTableRow('Glass Weight:', '${entry.glassWeight} kg'),
                  buildTableRow('Paper Weight:', '${entry.paperWeight} kg'),
                  buildTableRow('Organic Weight:', '${entry.organicWeight} kg'),
                  buildTableRow('Metal Weight:', '${entry.metalWeight} kg'),
                  buildTableRow('e-Waste Weight:', '${entry.eWasteWeight} kg'),
                  buildTableRow(
                    'Total Weight:',
                    '${entry.plasticWeight + entry.glassWeight + entry.paperWeight + entry.organicWeight + entry.metalWeight + entry.eWasteWeight} kg',
                  ),
                  buildTableRow('Total Points:', '${entry.totalPoints} points'),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                padding: const pw.EdgeInsets.all(10),
                child: pw.Text(
                  'Thank you for contributing to waste management!',
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.green900,
                    fontStyle: pw.FontStyle.italic,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'garbage_entry_summary.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade200, Colors.blue.shade200],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.green),
                  onPressed: () {
                    context.go('/home');
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsets.only(left: 120.0, bottom: 155.0),
                  title: const Text(
                    'Record Garbage',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  background: Image.asset(
                    'assets/garbage.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFieldInput(
                            icon: Icons.person,
                            title: "User ID",
                            controller: _userId,
                            inputType: TextInputType.text,
                            validator: Validators.nullCheck),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.local_drink,
                            title: "Plastic/Polythene (kg)",
                            controller: _plasticWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.wine_bar,
                            title: "Glass (kg)",
                            controller: _glassWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.article,
                            title: "Paper (kg)",
                            controller: _paperWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.grass,
                            title: "Organic (kg)",
                            controller: _organicWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.home_repair_service,
                            title: "Metal (kg)",
                            controller: _metalWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.memory,
                            title: "e-Waste (kg)",
                            controller: _eWasteWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 24),
                        const SizedBox(height: 24),
                        SubmitButton(
                            icon: Icons.send,
                            text: "Submit Entry",
                            whenPressed: _submitEntry)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
