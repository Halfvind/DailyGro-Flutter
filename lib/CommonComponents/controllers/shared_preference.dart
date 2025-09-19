import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences once
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      print('SharedPreferences initialized successfully');
    } catch (e) {
      print('Failed to initialize SharedPreferences: $e');
    }
  }

  // Set String value
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  // Get String value
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  // Set Int value
  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  // Get Int value
  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  // Remove a key
  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  // Clear all keys
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}

//set pref
//await SharedPrefHelper.setString('user_email', 'user@dailygro.com');

//get pref

//String? email = SharedPrefHelper.getString('user_email');
//print('User email: $email');

