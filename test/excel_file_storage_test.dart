import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_absensi_app/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI for tests
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Excel File Storage Tests', () {
    test('Save and retrieve Excel file with attendance data', () async {
      final testKey = 'test-excel-2024-12';
      final testData = '{"test": "attendance data"}';
      final testExcelBytes = List<int>.generate(100, (i) => i % 256);
      final testFilename = 'test_attendance.xlsx';

      // Save data with Excel file
      final saveResult = await DatabaseService.saveData(
        testKey,
        testData,
        excelFileBytes: testExcelBytes,
        excelFilename: testFilename,
      );
      expect(saveResult, isTrue);

      // Load attendance data
      final loadedData = await DatabaseService.loadData(testKey);
      expect(loadedData, equals(testData));

      // Load Excel file
      final excelData = await DatabaseService.getExcelFile(testKey);
      expect(excelData, isNotNull);
      expect(excelData!['bytes'], equals(testExcelBytes));
      expect(excelData['filename'], equals(testFilename));
    });

    test('Save attendance data without Excel file', () async {
      final testKey = 'test-no-excel-2024-12';
      final testData = '{"test": "attendance data without excel"}';

      // Save data without Excel file
      final saveResult = await DatabaseService.saveData(testKey, testData);
      expect(saveResult, isTrue);

      // Load attendance data
      final loadedData = await DatabaseService.loadData(testKey);
      expect(loadedData, equals(testData));

      // Try to load Excel file (should be null)
      final excelData = await DatabaseService.getExcelFile(testKey);
      expect(excelData, isNull);
    });

    test('Update Excel file for existing data', () async {
      final testKey = 'test-update-excel-2024-12';
      final testData1 = '{"test": "first version"}';
      final testData2 = '{"test": "second version"}';
      final testExcelBytes1 = List<int>.generate(50, (i) => i);
      final testExcelBytes2 = List<int>.generate(75, (i) => i * 2);
      final testFilename1 = 'first.xlsx';
      final testFilename2 = 'second.xlsx';

      // Save initial data
      await DatabaseService.saveData(
        testKey,
        testData1,
        excelFileBytes: testExcelBytes1,
        excelFilename: testFilename1,
      );

      // Update with new data and Excel file
      final updateResult = await DatabaseService.saveData(
        testKey,
        testData2,
        excelFileBytes: testExcelBytes2,
        excelFilename: testFilename2,
      );
      expect(updateResult, isTrue);

      // Verify updated data
      final loadedData = await DatabaseService.loadData(testKey);
      expect(loadedData, equals(testData2));

      // Verify updated Excel file
      final excelData = await DatabaseService.getExcelFile(testKey);
      expect(excelData, isNotNull);
      expect(excelData!['bytes'], equals(testExcelBytes2));
      expect(excelData['filename'], equals(testFilename2));
    });

    test('Delete data with Excel file', () async {
      final testKey = 'test-delete-excel-2024-12';
      final testData = '{"test": "to be deleted"}';
      final testExcelBytes = List<int>.generate(100, (i) => i);
      final testFilename = 'to_delete.xlsx';

      // Save data with Excel file
      await DatabaseService.saveData(
        testKey,
        testData,
        excelFileBytes: testExcelBytes,
        excelFilename: testFilename,
      );

      // Verify data exists
      expect(await DatabaseService.loadData(testKey), isNotNull);
      expect(await DatabaseService.getExcelFile(testKey), isNotNull);

      // Delete data
      final deleteResult = await DatabaseService.deleteData(testKey);
      expect(deleteResult, isTrue);

      // Verify both data and Excel file are deleted
      expect(await DatabaseService.loadData(testKey), isNull);
      expect(await DatabaseService.getExcelFile(testKey), isNull);
    });
  });
}
