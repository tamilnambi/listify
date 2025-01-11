// Package imports:

import 'package:shared_preferences/shared_preferences.dart';

import 'app_logger.dart';

class SharedPreferencesService {
  static SharedPreferences? prefs;
  static String isLoggedIn = "is_logged_in";
  static String phoneNumber = "phone_number";
  static String customerId = "customer_id";
  //static String distanceToStore = "distance_to_store";
  //static String isDeliverable = "is_deliverable";

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
