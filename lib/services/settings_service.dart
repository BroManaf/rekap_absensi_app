import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing application settings (small configuration data only)
/// 
/// Note: SharedPreferences is ONLY used here for small settings like database path.
/// Large data (attendance records) are stored in SQLite via DatabaseService.
/// This is the correct architectural pattern:
/// - SharedPreferences: Small settings, preferences (KB range)
/// - SQLite Database: Large structured data (MB-GB range)
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
