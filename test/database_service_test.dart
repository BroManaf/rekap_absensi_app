import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_absensi_app/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI for tests
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseService Tests', () {
    test('Save and load data', () async {
      // Initialize with an in-memory database for testing
      final testKey = 'test-2024-01';
      final testData = '{"test": "data"}';

      // Save data
      final saveResult = await DatabaseService.saveData(testKey, testData);
      expect(saveResult, isTrue);

      // Load data
      final loadedData = await DatabaseService.loadData(testKey);
      expect(loadedData, equals(testData));
    });

    test('Delete data', () async {
      final testKey = 'test-2024-02';
      final testData = '{"test": "data2"}';

      // Save data
      await DatabaseService.saveData(testKey, testData);

      // Verify data exists
      final loadedData = await DatabaseService.loadData(testKey);
      expect(loadedData, isNotNull);

      // Delete data
      final deleteResult = await DatabaseService.deleteData(testKey);
      expect(deleteResult, isTrue);

      // Verify data is deleted
      final deletedData = await DatabaseService.loadData(testKey);
      expect(deletedData, isNull);
    });

    test('Get all keys', () async {
      final testKey1 = 'test-2024-03';
      final testKey2 = 'test-2024-04';
      final testData = '{"test": "data"}';

      // Save test data
      await DatabaseService.saveData(testKey1, testData);
      await DatabaseService.saveData(testKey2, testData);

      // Get all keys
      final keys = await DatabaseService.getAllKeys();
      expect(keys, contains(testKey1));
      expect(keys, contains(testKey2));

      // Cleanup
      await DatabaseService.deleteData(testKey1);
      await DatabaseService.deleteData(testKey2);
    });
  });
}
