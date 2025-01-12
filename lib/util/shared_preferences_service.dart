// Package imports:

import 'package:shared_preferences/shared_preferences.dart';

import 'app_logger.dart';

class SharedPreferencesService {
  static SharedPreferences? prefs;
  static String isLoggedIn = "is_logged_in";
  static String userId = "user_id";

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> clearAllValues() async {
    if (prefs != null) {
      await prefs!.clear();
    } else {
      AppLogger().logError('SharedPreferences is null');
    }
  }

}
