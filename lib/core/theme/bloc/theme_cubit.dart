import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey);
      
      if (themeString != null) {
        final themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeString,
          orElse: () => ThemeMode.system,
        );
        emit(themeMode);
      }
    } catch (e) {
      // If there's an error loading the theme, stick with system theme
      emit(ThemeMode.system);
    }
  }

  Future<void> updateTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, themeMode.toString());
      emit(themeMode);
    } catch (e) {
      // Handle error - could log it
    }
  }

  void toggleTheme() {
    switch (state) {
      case ThemeMode.light:
        updateTheme(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        updateTheme(ThemeMode.system);
        break;
      case ThemeMode.system:
        updateTheme(ThemeMode.light);
        break;
    }
  }
}