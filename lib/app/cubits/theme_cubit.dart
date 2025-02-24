import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  // default lightTheme
  ThemeCubit() : super(AppTheme.lightTheme) {
    _loadInitialTheme();
  }

  // Constants for theme keys
  static const String _themeKey = 'themeMode';
  static const String lightThemeKey = 'light';
  static const String darkThemeKey = 'dark';
  static const String customThemeKey = 'custom';

  Future<void> _loadInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme == darkThemeKey) {
      emit(AppTheme.darkTheme);
    } else if (savedTheme == customThemeKey) {
      emit(AppTheme.customTheme);
    } else {
      emit(AppTheme.lightTheme); // Default to light theme
    }
  }

  Future<void> toggleTheme(String themeKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeKey);

    switch (themeKey) {
      case lightThemeKey:
        emit(AppTheme.lightTheme);
        break;
      case darkThemeKey:
        emit(AppTheme.darkTheme);
        break;
      case customThemeKey:
        emit(AppTheme.customTheme);
        break;
    }
  }
}
