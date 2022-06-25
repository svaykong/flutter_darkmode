import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  SharedPreferences prefs;

  ThemeService(this.prefs);

  Future<bool> toggleDarkMode(bool val) async {
    return await prefs.setBool("darkMode", val);
  }

  bool getPrefs() {
    bool? darkModePref = prefs.getBool("darkMode");
    bool darkMode;
    darkModePref != null 
    ? darkMode = darkModePref
    : darkMode = false;

    return darkMode;
  }

  Future<bool> deletePrefs() async {
    return await prefs.remove("darkMode");
  }
}
