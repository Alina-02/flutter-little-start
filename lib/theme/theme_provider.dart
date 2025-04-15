import 'package:flutter/material.dart';
import 'package:tutorial1/theme/brown_mode.dart';

import 'purple_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = purpleMode;

  ThemeData get themeData => _themeData;

  bool get isBrownMode => _themeData == brownMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == purpleMode) {
      themeData = brownMode;
    } else {
      themeData = purpleMode;
    }
  }
}
