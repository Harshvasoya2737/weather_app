import 'package:flutter/material.dart';
import 'package:weather_app/main.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  ThemeMode? get thememode {
    if (isDark == false) {
      return ThemeMode.light;
    } else if (isDark == true) {
      return ThemeMode.dark;
    } else {
      return null;
    }
  }

  void setTheme() {
    isDark = !isDark;
    prefs.setBool('theme', isDark);
    notifyListeners();
  }

  void getTheme() {
    isDark = prefs.getBool('theme') ?? false;
    notifyListeners();
  }
}