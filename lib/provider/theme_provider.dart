import 'package:flutter/material.dart';
import 'package:trai_new_ui/app/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  final AppTheme appTheme = AppTheme();
  
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData getTheme(BuildContext context) {
    return _isDarkMode ? appTheme.darkTheme(context) : appTheme.lightTheme(context);
  }
}