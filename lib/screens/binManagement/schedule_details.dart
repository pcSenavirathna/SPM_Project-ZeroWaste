import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:zero_waste/models/route_schedule.dart';
import 'package:zero_waste/repositories/route_schedule_repository.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';

class ScheduleDetails {
  Future<void> getDetails(BuildContext context) async {
    try {
      List<RouteSchedule> schedules =
          await RouteScheduleRepository().getSchedulesByDate();
      print(schedules.first.toMap());
      _generateAndDownloadPDF(schedules.first);
    } catch (error) {
      okMessageDialog(context, "Failed!", error.toString());
    }
  }

  Future<void> _generateAndDownloadPDF(RouteSchedule schedule) async {
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
                      'Schedule For ${DateTime.now()}',
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
                  buildTableRow('Driver ID:', schedule.driverId),
                  buildTableRow('Route Id:', schedule.routeId),
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
        bytes: await pdf.save(), filename: 'schedule_today.pdf');
  }
}
