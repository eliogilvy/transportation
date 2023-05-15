import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeMode _thememode = ThemeMode.light;
  bool isDarkMode = false;

  ThemeMode get themeMode => _thememode;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    _thememode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
