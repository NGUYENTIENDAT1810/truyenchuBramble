import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs?.setString(AppConstants.tokenKey, token);
  }

  static String? getToken() {
    return _prefs?.getString(AppConstants.tokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _prefs?.setString(AppConstants.refreshTokenKey, token);
  }

  static String? getRefreshToken() {
    return _prefs?.getString(AppConstants.refreshTokenKey);
  }

  static Future<void> saveUser(Map<String, dynamic> userMap) async {
    await _prefs?.setString(AppConstants.userKey, jsonEncode(userMap));
  }

  static Map<String, dynamic>? getUser() {
    final str = _prefs?.getString(AppConstants.userKey);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveReaderSettings(Map<String, dynamic> settings) async {
    await _prefs?.setString(AppConstants.readerSettingsKey, jsonEncode(settings));
  }

  static Map<String, dynamic>? getReaderSettings() {
    final str = _prefs?.getString(AppConstants.readerSettingsKey);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveSettingsPreferences(Map<String, dynamic> prefs) async {
    await _prefs?.setString(AppConstants.settingsPreferencesKey, jsonEncode(prefs));
  }

  static Map<String, dynamic>? getSettingsPreferences() {
    final str = _prefs?.getString(AppConstants.settingsPreferencesKey);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> setOnboardingCompleted(bool val) async {
    await _prefs?.setBool(AppConstants.onboardingCompletedKey, val);
  }

  static bool isOnboardingCompleted() {
    return _prefs?.getBool(AppConstants.onboardingCompletedKey) ?? false;
  }

  static Future<void> clearAuth() async {
    await _prefs?.remove(AppConstants.tokenKey);
    await _prefs?.remove(AppConstants.refreshTokenKey);
    await _prefs?.remove(AppConstants.userKey);
  }
}
