# Excel File Storage Feature - Implementation Summary

## Overview
Implemented functionality to save uploaded Excel files alongside attendance data in the database, allowing users to download the original Excel files later from the history screen.

## Changes Made

### 1. Database Schema Updates (`lib/services/database_service.dart`)
- **Version Update**: Database version increased from 1 to 2
- **New Columns**: 
  - `excel_file BLOB` - Stores the Excel file bytes
  - `excel_filename TEXT` - Stores the original filename
- **Migration**: Added `_onUpgrade` function to handle migration for existing databases
- **New Method**: `getExcelFile(String key)` - Retrieves Excel file data for a specific year-month

### 2. Storage Service Updates (`lib/services/attendance_storage_service.dart`)
- **Enhanced saveAttendanceData()**: Added optional parameters `excelFileBytes` and `excelFilename`
- **New Method**: `getExcelFile()` - Wrapper to retrieve Excel file from database by year and month

### 3. Attendance Screen Updates (`lib/screens/attendance_screen.dart`)
- **New State Variable**: `_currentExcelBytes` - Stores Excel file bytes after import
- **Enhanced _processExcelFile()**: Now captures and stores Excel file bytes and filename
- **Enhanced _saveData()**: Passes Excel file data to storage service when saving
- **Path Handling**: Uses `path.basename()` for proper cross-platform filename extraction

### 4. History Screen Updates (`lib/screens/historis_absensi_screen.dart`)
- **New Import**: Added `file_picker` and `path` packages
- **New Button**: "Download Excel" button added to the action bar
- **New Method**: `_downloadExcelFile()` 
  - Retrieves Excel file from database
  - Prompts user to select save location using FilePicker
  - Saves Excel file to selected location
  - Shows appropriate success/error messages

### 5. Testing (`test/excel_file_storage_test.dart`)
- Created comprehensive test suite covering:
  - Saving and retrieving Excel files with attendance data
  - Saving data without Excel files
  - Updating Excel files
  - Deleting data with Excel files

## User Flow

### Saving Excel File:
1. User uploads Excel file in "Rekap Absensi" menu
2. System processes the file and stores both:
   - Attendance data (as before)
   - Excel file bytes and filename (NEW)
3. User clicks "Simpan Data" button
4. Both attendance data and Excel file are saved to database

### Downloading Excel File:
1. User navigates to "Historis Absensi" menu
2. User selects a specific month/year from sidebar
3. New "Download Excel" button appears next to "Hapus Data" button
4. User clicks "Download Excel"
5. System checks if Excel file exists for that period
6. If exists, file picker dialog opens for user to choose save location
7. File is saved to selected location with original or default filename

## Technical Details

### File Storage Format
- Excel files are stored as BLOB in SQLite database
- Files are stored as List<int> (byte array)
- Original filename is preserved when available
- Default filename format: `Absensi_{MonthName}_{Year}.xlsx`

### Database Migration
- Existing databases automatically migrate to version 2
- New columns are added using ALTER TABLE
- Existing data remains intact
- Old data will not have Excel files (null values)

### Error Handling
- Graceful handling when Excel file is not available
- User-friendly error messages
- Proper validation before save/download operations

## Benefits

1. **Data Integrity**: Original Excel files are preserved alongside processed data
2. **Auditability**: Users can download and verify original source files
3. **Flexibility**: Users can re-process or share original files when needed
4. **Backward Compatible**: Works with existing data (Excel file is optional)

## Future Enhancements (Optional)

1. Preview Excel file in-app using Excel package
2. Export modified data back to Excel format
3. Compare uploaded Excel with saved Excel for verification
4. File size optimization/compression for large files
