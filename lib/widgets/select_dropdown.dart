import 'package:flutter/material.dart';

class SelectDropdown extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String hint;

  const SelectDropdown({
    super.key,
    required this.items,
    required this.title,
    required this.selectedValue,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(
                  hint,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                value: selectedValue,
                onChanged: onChanged,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                iconSize: 24,
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
