import 'package:flutter/material.dart';

class AppThemes {

  // Light theme
  static final lightTheme = ThemeData(
    primarySwatch: Colors.teal,
    colorScheme: const ColorScheme.light(
      primary: Color(0x00069349),//"#069349 "
      secondary: Color(0x00e2e1e1),//"#E2E1E1 "
      tertiary: Color(0x004B4B4B),//"#4B4B4B "
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.teal),
      bodyLarge: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black54),
    ),
    iconTheme: const IconThemeData(
      color: Colors.tealAccent,
      size: 24,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  // Dark theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    colorScheme: ColorScheme.dark(
      primary: Colors.teal,
      secondary: Colors.amber,
      surface: Colors.grey[900]!,
      error: Colors.red[400]!,
    ),
    textTheme: TextTheme(
      displayLarge: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.tealAccent),
      bodyLarge: const TextStyle(fontSize: 16.0, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.grey[300]),
    ),
    iconTheme: const IconThemeData(
      color: Colors.tealAccent,
      size: 24,
    ),
    scaffoldBackgroundColor: Colors.grey[900],
  );
}
