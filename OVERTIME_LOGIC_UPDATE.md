# Overtime Logic Update - Implementation Summary

## Overview
This document describes the changes made to implement the new overtime calculation logic as per the requirements.

## Changes Made

### 1. Field Redefinition: `jamMasukLembur`
**Previous behavior:** Represented the time when an employee clocked in for overtime work.

**New behavior:** Represents the final clock-out time for the day (including any overtime).

**Rationale:** Simplifies the Excel template and attendance tracking by eliminating the need for a separate overtime clock-out column.

### 2. Field Deprecation: `jamKeluarLembur`
**Previous behavior:** Represented the time when an employee clocked out from overtime.

**New behavior:** No longer used in calculations (kept in the `AttendanceRecord` model for backward compatibility with existing Excel files).

**Rationale:** With `jamMasukLembur` now serving as the final clock-out time, `jamKeluarLembur` is redundant.

### 3. Shift Boundary Updates

| Shift | Previous | New | Change |
|-------|----------|-----|--------|
| Pagi (Morning) | 07:00 - 12:00 | 07:00 - 12:00 | No change |
| Siang (Afternoon) | 12:01 - 18:00 | 12:01 - 16:00 | End time moved from 18:00 to 16:00 |
| Lembur (Overtime) | 18:01 - 23:59 | 17:01 - 05:00 | Start time moved from 18:01 to 17:01 |

### 4. Gap Time Handling (16:00 - 17:01)
**New behavior:** Time between 16:00 (end of afternoon shift) and 17:01 (start of overtime) is NOT counted as work time.

**Rationale:** Provides a clear separation between regular work hours and overtime, with a buffer period that is not counted.

### 5. Overtime Calculation Logic
**Trigger condition:** Overtime is only counted if the final clock-out time is at or after 17:01.

**Calculation base:** When overtime is triggered, it is calculated from 17:00 (not 17:01).

**Example:**
- Clock out at 17:00 → No overtime (gap time only)
- Clock out at 17:01 → 1 minute overtime (17:00 to 17:01)
- Clock out at 20:00 → 180 minutes overtime (17:00 to 20:00 = 3 hours)

## Implementation Details

### Modified Function: `calculateWorkDuration`
Located in: `lib/services/attendance_service.dart`

**Logic:**
1. **Case 1:** Checkout ≤ 16:00 → Simple calculation (checkIn to checkOut)
2. **Case 2:** 16:00 < Checkout < 17:01 → Count only up to 16:00 (gap not counted)
3. **Case 3:** Checkout ≥ 17:01 → Split calculation:
   - Regular hours: checkIn to 16:00
   - Overtime hours: 17:00 to checkOut

### Modified Function: `processDailyAttendance`
Located in: `lib/services/attendance_service.dart`

**Changes:**
- `jamMasukLembur` is now parsed as `lemburAsCheckOut` (a clock-out time)
- `jamKeluarLembur` is no longer parsed or used
- Check-in times no longer include `jamMasukLembur`
- Check-out times prioritize `lemburAsCheckOut` as the final clock-out

## Example Calculation

### Scenario: Quarry Employee with Overtime
**Input:**
- Department: Quarry (standard clock-in: 07:00)
- Clock in (Jam Masuk Pagi): 08:00
- Clock out (Jam Masuk Lembur): 20:00

**Calculation:**
- **LamaTelat (Lateness):** 08:00 - 07:00 = 60 minutes (1 hour)
- **LamaMasuk (Work Duration):**
  - Regular hours: 08:00 to 16:00 = 480 minutes (8 hours)
  - Gap: 16:00 to 17:01 = NOT COUNTED
  - Overtime: 17:00 to 20:00 = 180 minutes (3 hours)
  - **Total:** 480 + 180 = 660 minutes (11 hours)

## Test Coverage

### New Tests Added:
1. Checkout at exactly 16:00 (no overtime)
2. Checkout at 16:30 (between shifts - gap not counted)
3. Checkout at exactly 17:00 (no overtime - below threshold)
4. Checkout at exactly 17:01 (overtime starts)
5. Quarry employee with overtime (problem statement example)

### Updated Tests:
1. Calculate work duration with late arrival
2. Process daily attendance - Example 1 (Late arrival)
3. Process daily attendance - With overtime
4. Calculate summary for multiple days

## Documentation Updates

### Files Updated:
- `EXCEL_FORMAT.md`: Updated shift definitions, column descriptions, and examples
- This document: Created to summarize the implementation

## Backward Compatibility

### Excel Files:
- Old Excel files with `jamKeluarLembur` data will still be parsed correctly
- The `jamKeluarLembur` field is simply ignored in calculations
- No data migration is required

### Code:
- `AttendanceRecord` model still contains `jamKeluarLembur` field
- No breaking changes to the API or data structures

## Testing Recommendations

### Manual Testing:
1. Test with Excel file containing employees who:
   - Clock out before 16:00 (no overtime)
   - Clock out between 16:00 and 17:01 (gap period)
   - Clock out at or after 17:01 (with overtime)
2. Verify calculations match expected values
3. Check that old Excel files still work correctly

### Automated Testing:
- Run: `flutter test test/attendance_service_test.dart`
- All tests should pass

## Security Considerations
- No security vulnerabilities introduced
- No sensitive data handling changes
- CodeQL scan: Not applicable (Dart language not supported)

## Performance Impact
- Minimal performance impact
- Calculation complexity remains O(1) per attendance record
- No additional database queries or file I/O

## Future Considerations

### Potential Enhancements:
1. Add support for night shift overtime (17:01 to 05:00 next day)
2. Make shift boundaries configurable per department
3. Add visual indicators in UI for gap time vs. overtime
4. Generate detailed overtime reports

### Maintenance:
- Consider removing `jamKeluarLembur` field from model in a future major version
- Add automated tests for Excel parsing when Flutter is available in CI/CD

## Conclusion
The implementation successfully addresses all requirements from the problem statement:
- ✅ `jamMasukLembur` now functions as final clock-out time
- ✅ `jamKeluarLembur` removed from calculations
- ✅ Afternoon shift ends at 16:00 (changed from 18:00)
- ✅ Overtime starts at 17:01 and is calculated from 17:00
- ✅ Gap time (16:00-17:01) is not counted
- ✅ Example calculation verified (Quarry employee: 08:00-20:00 = 11 hours)
