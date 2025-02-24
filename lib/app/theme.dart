import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // ... other theme data
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // ... other theme data
  );

  static final ThemeData customTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green,
    // ... other theme data
  );
}
