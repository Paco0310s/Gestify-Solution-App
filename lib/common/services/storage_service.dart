import 'package:gestify_solution/common/constants/app_config.dart';
import 'package:gestify_solution/common/logging/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      AppLogger.error('StorageService not initialized. Call init() first.');
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // String methods
  static Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  static String? getString(String key) {
    return prefs.getString(key);
  }

  // int methods
  static Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return prefs.getInt(key);
  }

  // JSON methods
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await setString(key, jsonEncode(value));
  }

  static Map<String, dynamic>? getJson(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Remove methods
  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  static Future<bool> clear() async {
    return await prefs.clear();
  }

  // Check if key exists
  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  /// Retrieves the current username either extracted from the JWT access token or from storage.
  static String? getUsername() {
    final token = getString(AppConfig.accessTokenKey);
    if (token != null) {
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          final normalized = base64Url.normalize(parts[1]);
          final payload = jsonDecode(utf8.decode(base64Url.decode(normalized))) as Map<String, dynamic>;
          final username = payload['preferred_username'] as String?;
          if (username != null && username.isNotEmpty) {
            setString(AppConfig.userNameKey, username);
            return username;
          }
        }
      } catch (_) {}
    }

    final stored = getString(AppConfig.userNameKey);
    if (stored != null && stored.isNotEmpty) return stored;

    return null;
  }
}
