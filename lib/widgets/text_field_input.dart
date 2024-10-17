import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final String title;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType inputType;

  const TextFieldInput({
    super.key,
    required this.icon,
    required this.title,
    required this.controller,
    required this.inputType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: Icon(icon, color: Colors.green),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        validator: validator,
        controller: controller,
        keyboardType: inputType,
      ),
    );
  }
}
