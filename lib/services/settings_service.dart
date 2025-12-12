import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _databasePathKey = 'database_path';

  /// Get the custom database path
  static Future<String?> getDatabasePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_databasePathKey);
  }

  /// Set the custom database path
  static Future<bool> setDatabasePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_databasePathKey, path);
  }

  /// Clear the custom database path (revert to default)
  static Future<bool> clearDatabasePath() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_databasePathKey);
  }
}
