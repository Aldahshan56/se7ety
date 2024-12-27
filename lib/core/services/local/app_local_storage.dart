import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
class AppLocalStorage {
  static late SharedPreferences _preferences;
  static String kUserType = 'userType';
  static String kOnBoarding = 'onBoarding';
  static String isDarkModeKey = "isDarkMode";
  static ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    bool isDarkMode = _preferences.getBool(isDarkModeKey) ?? false;
    isDarkModeNotifier.value = isDarkMode;
  }

  static cacheData({required String key, dynamic value}) {
    if (value is String) {
      _preferences.setString(key, value);
    } else if (value is bool) {
      _preferences.setBool(key, value);
    } else if (value is int) {
      _preferences.setInt(key, value);
    } else if (value is double) {
      _preferences.setDouble(key, value);
    } else {
      _preferences.setStringList(key, value);
    }
  }

  static dynamic getData({required String key}) {
    return _preferences.get(key);
  }
  static Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  static Future<void> setDarkMode(bool isDarkMode) async {
    await _preferences.setBool(isDarkModeKey, isDarkMode);
    isDarkModeNotifier.value = isDarkMode;
  }
}
