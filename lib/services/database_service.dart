import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'settings_service.dart';

class DatabaseService {
  static Database? _database;
  static String? _currentDatabasePath;

  /// Initialize the database
  static Future<void> initialize() async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      // Initialize FFI for desktop platforms
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Get the database path from settings or use default
    final customPath = await SettingsService.getDatabasePath();
    if (customPath != null && customPath.isNotEmpty) {
      _currentDatabasePath = customPath;
    } else {
      // Use default path
      _currentDatabasePath = await _getDefaultDatabasePath();
      await SettingsService.setDatabasePath(_currentDatabasePath!);
    }

    await _openDatabase();
  }

  /// Get the default database path
  static Future<String> _getDefaultDatabasePath() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String dbDir = path.join(appDocDir.path, 'rekap_absensi');
    
    // Create directory if it doesn't exist
    final Directory dir = Directory(dbDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    
    return path.join(dbDir, 'attendance.db');
  }

  /// Open the database
  static Future<void> _openDatabase() async {
    _database = await databaseFactory.openDatabase(
      _currentDatabasePath!,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  /// Create database tables
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE attendance_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        year_month TEXT NOT NULL UNIQUE,
        data TEXT NOT NULL,
        excel_file BLOB,
        excel_filename TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_year_month ON attendance_data(year_month)
    ''');
  }

  /// Handle database upgrades
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add excel_file and excel_filename columns for version 2
      await db.execute('ALTER TABLE attendance_data ADD COLUMN excel_file BLOB');
      await db.execute('ALTER TABLE attendance_data ADD COLUMN excel_filename TEXT');
    }
  }

  /// Get the database instance
  static Future<Database> get database async {
    if (_database == null) {
      await initialize();
    }
    return _database!;
  }

  /// Get the current database path
  static String? get currentDatabasePath => _currentDatabasePath;

  /// Change database location
  static Future<bool> changeDatabaseLocation(String newPath) async {
    try {
      // Always treat newPath as a directory and create the database file path
      String finalPath;
      if (newPath.endsWith('.db')) {
        // If user somehow provides a .db file path, use it as-is
        finalPath = newPath;
      } else {
        // Treat as directory and append database filename
        finalPath = path.join(newPath, 'attendance.db');
      }

      // Create directory if it doesn't exist
      final directory = Directory(path.dirname(finalPath));
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Close current database
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      // Copy old database to new location if it exists
      // Note: We copy (not move) for safety. The old file stays as backup.
      // Users can manually delete the old database file after verifying the new location works.
      if (_currentDatabasePath != null && _currentDatabasePath != finalPath) {
        final oldFile = File(_currentDatabasePath!);
        if (await oldFile.exists()) {
          await oldFile.copy(finalPath);
          debugPrint('[DatabaseService] Database copied from $_currentDatabasePath to $finalPath');
        }
      }

      // Update the path
      _currentDatabasePath = finalPath;
      await SettingsService.setDatabasePath(finalPath);

      // Open new database
      await _openDatabase();

      return true;
    } catch (e) {
      debugPrint('Error changing database location: $e');
      return false;
    }
  }

  /// Save data to database
  static Future<bool> saveData(String key, String jsonData, {List<int>? excelFileBytes, String? excelFilename}) async {
    try {
      final db = await database;
      final now = DateTime.now().toIso8601String();
      
      await db.insert(
        'attendance_data',
        {
          'year_month': key,
          'data': jsonData,
          'excel_file': excelFileBytes,
          'excel_filename': excelFilename,
          'created_at': now,
          'updated_at': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      return true;
    } catch (e) {
      debugPrint('Error saving data: $e');
      return false;
    }
  }

  /// Load data from database
  static Future<String?> loadData(String key) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        'attendance_data',
        where: 'year_month = ?',
        whereArgs: [key],
      );
      
      if (results.isEmpty) {
        return null;
      }
      
      return results.first['data'] as String;
    } catch (e) {
      debugPrint('Error loading data: $e');
      return null;
    }
  }

  /// Delete data from database
  static Future<bool> deleteData(String key) async {
    try {
      final db = await database;
      await db.delete(
        'attendance_data',
        where: 'year_month = ?',
        whereArgs: [key],
      );
      
      return true;
    } catch (e) {
      debugPrint('Error deleting data: $e');
      return false;
    }
  }

  /// Get all available keys
  static Future<List<String>> getAllKeys() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        'attendance_data',
        columns: ['year_month'],
        orderBy: 'year_month DESC',
      );
      
      return results.map((row) => row['year_month'] as String).toList();
    } catch (e) {
      debugPrint('Error getting all keys: $e');
      return [];
    }
  }

  /// Get Excel file data for a specific key
  static Future<Map<String, dynamic>?> getExcelFile(String key) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        'attendance_data',
        columns: ['excel_file', 'excel_filename'],
        where: 'year_month = ?',
        whereArgs: [key],
      );
      
      if (results.isEmpty || results.first['excel_file'] == null) {
        return null;
      }
      
      return {
        'bytes': results.first['excel_file'] as List<int>,
        'filename': results.first['excel_filename'] as String?,
      };
    } catch (e) {
      debugPrint('Error getting Excel file: $e');
      return null;
    }
  }

  /// Close the database
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
