# Manual Testing Guide

## Prerequisites
1. Ensure Flutter is installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter test` to execute automated tests

## Automated Tests
The test file `test/attendance_service_test.dart` contains comprehensive tests for:
- Time parsing functionality
- Lateness calculation
- Work duration calculation
- Daily attendance processing
- Multi-day summary calculation
- Department detection

### Running Tests
```bash
flutter test test/attendance_service_test.dart
```

Expected: All tests should pass ✓

## Manual UI Testing

### Test Case 1: Upload Valid Excel File
1. Launch the application
2. Navigate to "Rekap Absensi" menu
3. Create an Excel file with the following structure:
   - Row 2, Column C-G: "Quarry"
   - Row 2, Column I-K: "John Doe"
   - Row 3, Column I-K: "EMP001"
   - Row 12 (Day 1):
     - Column C: "07:00" (masuk pagi)
     - Column H: "17:00" (keluar siang)
   - Row 13 (Day 2):
     - Column C: "09:00" (masuk pagi)
     - Column H: "18:00" (keluar siang)
4. Upload the file
5. Verify:
   - Employee "John Doe" appears in the table
   - UserID shows "EMP001"
   - Department shows "Quarry"
   - TotalMasuk shows correct hours
   - TotalTelat shows correct hours

### Test Case 2: Early Arrival Scenario
Create Excel with:
- Row 12: Column C = "06:45", Column H = "12:40"
- Expected: LamaTelat = 0, LamaMasuk = 340 minutes (5h 40m)

### Test Case 3: Late Arrival Scenario
Create Excel with:
- Row 12: Column C = "09:00", Column H = "18:00"
- Expected: LamaTelat = 120 minutes (2h), LamaMasuk = 540 minutes (9h)

### Test Case 4: Multiple Employees
Create Excel with multiple sheets, each representing one employee:
- Sheet 1: John Doe (Quarry)
- Sheet 2: Jane Smith (Office)
- Verify both employees appear in the summary table

### Test Case 5: Empty Data Handling
Create Excel with:
- Some rows having empty time values
- Verify application doesn't crash
- Only days with data are counted

### Test Case 6: Different Departments
Test each department type:
- Staff (07:00 start)
- Quarry (07:00 start)
- Office (08:00 start)
- Intern (09:00 start)
- Beban (10:00 start)

Verify lateness is calculated correctly based on department start time.

## Expected Results

### Calculation Examples

#### Example 1: Quarry Employee - Late Arrival
- Check-in: 09:00
- Check-out: 18:00
- Department start: 07:00
- **Expected LamaTelat**: 120 minutes (2 hours)
- **Expected LamaMasuk**: 540 minutes (9 hours)

#### Example 2: Quarry Employee - Early Arrival
- Check-in: 06:45
- Check-out: 12:40
- Department start: 07:00
- **Expected LamaTelat**: 0 minutes
- **Expected LamaMasuk**: 340 minutes (5h 40m)

#### Example 3: Office Employee - On Time
- Check-in: 08:00
- Check-out: 17:00
- Department start: 08:00
- **Expected LamaTelat**: 0 minutes
- **Expected LamaMasuk**: 540 minutes (9 hours)

## UI Verification Checklist
- [ ] Drag & drop works
- [ ] File picker works
- [ ] Loading indicator appears during processing
- [ ] Success message shows after upload
- [ ] Error message shows for invalid files
- [ ] Table displays all employees
- [ ] Employee data is accurate
- [ ] Formatting is readable (hours/minutes)
- [ ] Can upload new file (clears previous data)
- [ ] Sidebar navigation works
- [ ] Layout is responsive

## Performance Testing
- Test with large Excel files (100+ employees)
- Verify no UI freeze during processing
- Check memory usage is reasonable

## Edge Cases to Test
- [ ] Empty Excel file
- [ ] Excel with no sheets
- [ ] Excel with headers only (no data rows)
- [ ] Invalid time formats (e.g., "25:00", "ab:cd")
- [ ] Negative time values
- [ ] Time values crossing midnight
- [ ] Non-Excel files (should be rejected)
- [ ] Corrupted Excel files
