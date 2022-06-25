import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/theme_service.dart';

/* Notes::: 
   ThemeMode.system: for follow system theme
   ThemeMode.light: for light theme 
   ThemeMode.dark: for dark theme */

// noted: What is with keyword here
class ThemeNotifier with ChangeNotifier {
  // light theme settings
  final lighTheme = ThemeData(brightness: Brightness.light);

  // dark theme settings
  final darkTheme = ThemeData(brightness: Brightness.dark);

  // we tell the _themwService with late keyword that we initial value it later 
  late ThemeService _themeService;

  // get _darkModePrefs from shared_preferences
  bool _darkModePrefs = false;
  bool getDarkModePres() => _darkModePrefs;

  // initial default value for field _themeData
  ThemeData _themeData = ThemeData.light();
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    // Here we start initialize value for _themeService
    SharedPreferences.getInstance().then((prefs) {
      _themeService = ThemeService(prefs);

      final getDarkModePrefs = _themeService.getPrefs();
      _darkModePrefs = getDarkModePrefs;

      if (getDarkModePrefs) {
        _themeData = darkTheme;
      } else {
        _themeData = lighTheme;
      }

      // tell the widget to listen to this event, prevent it rebuild
      notifyListeners();
    });
  }

  void setLightMode() {
    _themeData = lighTheme;

    // save the bool to the cache
    _themeService.toggleDarkMode(false);

    // tell the widget to listen to this event, prevent it rebuild
    notifyListeners();
  }

  void setDarkMode() {
    _themeData = darkTheme;

    // save the bool to the cache
    _themeService.toggleDarkMode(true);

    // tell the widget to listen to this event, prevent it rebuild
    notifyListeners();
  }
}
