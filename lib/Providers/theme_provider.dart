import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  var _thememode = ThemeMode.dark;

  ThemeMode get themeMode => _thememode;

  void setTheme(themeMode) {
    _thememode = themeMode;
    notifyListeners();
  }
}
