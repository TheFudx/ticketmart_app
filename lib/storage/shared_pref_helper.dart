import 'package:shared_preferences/shared_preferences.dart';

import 'shared_pref_keys.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  // User ID
  static Future<void> setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedPrefKeys.userId, userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedPrefKeys.userId);
  }

  // User Email
  static Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.email, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKeys.email);
  }

  // User Mobile
  static Future<void> setUserMobile(String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.mobile, mobile);
  }

  static Future<String?> getUserMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKeys.mobile);
  }

  // User token
  static Future<void> setUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.token, token);
  }

  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKeys.token);
  }

  static Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
