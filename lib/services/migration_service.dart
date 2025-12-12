import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';

class MigrationService {
  static const String _oldStorageKey = 'attendance_history';
  static const String _migrationCompleteKey = 'migration_to_sqlite_complete';

  /// Check if migration is needed and perform it
  static Future<bool> migrateIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if migration was already completed
      final migrationComplete = prefs.getBool(_migrationCompleteKey) ?? false;
      if (migrationComplete) {
        debugPrint('[Migration] Already completed, skipping...');
        return true;
      }

      // Check if old data exists
      final String? oldData = prefs.getString(_oldStorageKey);
      if (oldData == null || oldData.isEmpty) {
        debugPrint('[Migration] No old data found, marking as complete');
        await prefs.setBool(_migrationCompleteKey, true);
        return true;
      }

      debugPrint('[Migration] Starting migration from SharedPreferences to SQLite...');

      // Parse old data
      final Map<String, dynamic> allData = json.decode(oldData);
      
      int migratedCount = 0;
      int errorCount = 0;

      // Migrate each month's data
      for (var entry in allData.entries) {
        try {
          final key = entry.key;
          final value = entry.value;
          
          // Convert to JSON string
          final jsonData = json.encode(value);
          
          // Save to new database
          final success = await DatabaseService.saveData(key, jsonData);
          
          if (success) {
            migratedCount++;
            debugPrint('[Migration] Migrated: $key');
          } else {
            errorCount++;
            debugPrint('[Migration] Failed to migrate: $key');
          }
        } catch (e) {
          errorCount++;
          debugPrint('[Migration] Error migrating ${entry.key}: $e');
        }
      }

      // Mark migration as complete
      await prefs.setBool(_migrationCompleteKey, true);
      
      // Optionally, remove old data to free up space
      // Uncomment the following line if you want to delete old data after successful migration
      // await prefs.remove(_oldStorageKey);

      debugPrint('[Migration] Completed! Migrated: $migratedCount, Errors: $errorCount');
      
      return errorCount == 0;
    } catch (e) {
      debugPrint('[Migration] Error during migration: $e');
      return false;
    }
  }

  /// Reset migration flag (for testing purposes)
  static Future<void> resetMigrationFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_migrationCompleteKey);
  }
}
