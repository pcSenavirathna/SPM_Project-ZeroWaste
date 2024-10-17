import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final IconData icon;
  void Function(BuildContext) whenPressed;

  SubmitButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.whenPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => whenPressed(context),
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
