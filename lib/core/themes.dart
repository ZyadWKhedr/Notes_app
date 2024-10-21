import 'package:flutter/material.dart';

// Theme data for light and dark themes
class AppTheme {
  static ThemeData light() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      cardColor: Colors.white,
      scaffoldBackgroundColor: Colors.grey[100],
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black54),
        titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey,
      cardColor: Colors.black54,
      scaffoldBackgroundColor: Colors.grey[900],
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
