import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class AppDatePicker extends StatefulWidget {
  final String title;
  final ValueChanged<DateTime?>? onChangedDate;

  const AppDatePicker({super.key, required this.title, this.onChangedDate});

  @override
  State<AppDatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<AppDatePicker> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                DateTime? datePicked = await DatePicker.showSimpleDatePicker(
                  context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1880),
                  lastDate: DateTime(2050),
                  dateFormat: "dd-MMMM-yyyy",
                  locale: DateTimePickerLocale.en_us,
                  looping: true,
                );

                if (datePicked != null) {
                  setState(() {
                    selectedDate = datePicked;
                  });
                  if (widget.onChangedDate != null) {
                    widget.onChangedDate!(selectedDate);
                  }
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: selectedDate != null
                        ? selectedDate.toString()
                        : widget.title,
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
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
