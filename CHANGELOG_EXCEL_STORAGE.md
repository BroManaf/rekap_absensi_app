# Changelog - Excel File Storage Feature

## Version 1.1.0 (December 2024)

### Added
- **Excel File Storage**: Original Excel files are now saved alongside attendance data
- **Download Functionality**: New "Download Excel" button in History screen to retrieve original files
- **Database Migration**: Automatic upgrade from v1 to v2 with backward compatibility
- **Shared Utilities**: New `DateUtils` class for reusable date/month formatting
- **Comprehensive Tests**: Full test coverage for Excel file storage operations
- **User Documentation**: 
  - `EXCEL_FILE_STORAGE_IMPLEMENTATION.md` - Technical implementation guide
  - `PANDUAN_PENYIMPANAN_EXCEL.md` - Indonesian user guide with FAQs

### Changed
- **Database Schema**: Added `excel_file` (BLOB) and `excel_filename` (TEXT) columns
- **AttendanceStorageService**: Enhanced `saveAttendanceData()` with optional Excel file parameters
- **AttendanceScreen**: Now captures and stores Excel file bytes during import
- **HistorisAbsensiScreen**: Added download button and file picker integration
- **Code Quality**: Eliminated duplicate `_getMonthName()` methods using shared utility

### Improved
- **Error Handling**: Robust validation and error messages for all operations
- **Type Safety**: Enhanced type checking for BLOB data retrieval
- **Input Validation**: Month parameter validation (1-12) in DateUtils
- **User Experience**: Clear feedback messages for all save/download operations
- **Cross-platform**: Proper path handling using `path` package

### Technical Details

#### Database Changes
```sql
-- Version 2 Schema
ALTER TABLE attendance_data ADD COLUMN excel_file BLOB;
ALTER TABLE attendance_data ADD COLUMN excel_filename TEXT;
```

#### New API Methods
```dart
// Database Service
Future<Map<String, dynamic>?> getExcelFile(String key)

// Attendance Storage Service  
Future<Map<String, dynamic>?> getExcelFile({required int year, required int month})
Future<bool> saveAttendanceData({
  required int year,
  required int month,
  required List<AttendanceSummary> summaries,
  List<int>? excelFileBytes,
  String? excelFilename,
})
```

### Commits

1. `0239d9f` - Initial plan
2. `e891a86` - Add Excel file storage to database with download functionality
3. `b93b9c9` - Add proper path handling and Excel file storage tests
4. `805a164` - Refactor: Extract getMonthName to shared utility class
5. `01125c7` - Improve error handling and type safety for Excel file operations
6. `8059612` - Update documentation with comprehensive implementation details
7. `d740c64` - Add Indonesian user guide for Excel file storage feature

### Migration Notes

**For Existing Users:**
- Database will automatically upgrade to version 2 on first app launch
- Existing attendance data will remain intact
- Old data will not have Excel files (null values) - this is expected and normal
- No action required from users

**For Developers:**
- No breaking changes to existing API
- New optional parameters are backward compatible
- Tests should be updated if mocking database operations

### Breaking Changes
None - This is a backward compatible feature addition.

### Known Issues
None at this time.

### Dependencies
No new dependencies added. Existing packages used:
- `file_picker: ^8.1.4` (already present)
- `path: ^1.9.0` (already present)
- `sqflite_common_ffi: ^2.3.0` (already present)

### Browser/Platform Support
- ✅ Windows
- ✅ macOS  
- ✅ Linux
- ⚠️ Web (file_picker has limited web support)
- ⚠️ Mobile (not primary target platform)

### Performance Impact
- Minimal impact on load times
- Database size will increase based on Excel file sizes
- BLOB retrieval is efficient and cached by SQLite

### Security Considerations
- Excel files stored securely in local database
- No data transmitted over network
- File type validation on download
- Proper error handling prevents data leakage

### Testing Coverage
- ✅ Save Excel file with attendance data
- ✅ Save data without Excel file
- ✅ Retrieve Excel file
- ✅ Update existing Excel file
- ✅ Delete data with Excel file
- ✅ Input validation
- ✅ Error handling

### Acknowledgments
Implemented based on user requirement: "sekarang buat agar ketika user mengimport file excel ke menu rekap absen, lalu ketika sudah di review dan user klik simpan, maka simpan juga file excel nya di historis absen sesuai bulan dan tahun nya layaknya data data list itu. dan buatkan juga tombol untuk preview atau download excel nya"
