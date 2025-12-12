# Annual Recap Feature Implementation

## Overview
The Annual Recap feature displays attendance data for each employee across all 12 months of a selected year. This allows users to see a comprehensive yearly view of attendance metrics including days present (masuk), days late (telat), and days with overtime (lembur) for each employee, organized by month.

## Changes Made

### 1. New Model: `lib/models/annual_recap.dart`
Created data models to represent annual attendance data:

- **`MonthlyData`**: Represents attendance data for a single month
  - `month`: Month number (1-12)
  - `daysMasuk`: Number of days present
  - `daysTelat`: Number of days late
  - `daysLembur`: Number of days with overtime
  - `hasData`: Boolean getter to check if month has any data

- **`EmployeeAnnualRecap`**: Represents yearly data for one employee
  - `employee`: Employee object
  - `year`: Year number
  - `monthlyData`: Map of month (1-12) to MonthlyData
  - `getMonthData(month)`: Method to retrieve data for a specific month
  - `hasAnyData`: Boolean getter to check if employee has any data for the year

### 2. New Service: `lib/services/annual_recap_service.dart`
Created service to aggregate and retrieve annual recap data:

- **`getAnnualRecap(year)`**: Retrieves annual recap for all employees in a given year
  - Loads data from all 12 months
  - Aggregates employee data across months
  - Returns sorted list of EmployeeAnnualRecap objects

- **`getEmployeeAnnualRecap(userId, year)`**: Gets annual recap for a single employee
  - Loads data for specific employee across all 12 months
  - Returns EmployeeAnnualRecap or null if no data found

- **`getAvailableYears()`**: Returns list of years that have attendance data
  - Sorted in descending order (newest first)

### 3. New Screen: `lib/screens/annual_recap_screen.dart`
Created full-featured screen to display annual recap:

- **Header Section**:
  - Title: "Annual Recap"
  - Subtitle showing selected year
  - Employee count

- **Search Functionality**:
  - Search by User ID or employee name
  - Real-time filtering
  - Clear search button

- **Annual Recap Table**:
  - Horizontally scrollable to accommodate all 12 months
  - Fixed employee name column (200px width)
  - 12 month columns (90px each) with abbreviated month names
  - Each month cell displays:
    - Days present (green check icon + count)
    - Days late (orange clock icon + count)
    - Days overtime (indigo moon icon + count)
  - Empty cells show "-" for months with no data
  - Alternating row colors for readability

- **Empty States**:
  - When no year selected: "Pilih tahun dari sidebar"
  - When year has no data: "Tidak ada data untuk tahun {year}"

### 4. Modified `lib/screens/historis_absensi_screen.dart`
Updated to integrate the annual recap screen:

- Added import for `annual_recap_screen.dart`
- Modified `build()` method to show `AnnualRecapScreen` when `_isAnnualRecap` is true
- Updated `loadData()` method to handle Annual Recap case (month = 0)
- When Annual Recap is selected, the entire screen is replaced with AnnualRecapScreen

### 5. Sidebar Integration (Pre-existing)
The sidebar already had "Annual Recap" menu item from previous work:

- Located in `lib/widgets/historis_sidebar.dart`
- "Annual Recap" appears at top of each year's expanded month list
- Uses `month = 0` to identify Annual Recap selection
- Maintains consistent UI style with monthly items

### 6. New Tests: `test/annual_recap_service_test.dart`
Created comprehensive tests for the annual recap service:

- Test getting annual recap with no data
- Test getting annual recap with sample data across multiple months
- Test getting individual employee annual recap
- Test getting list of available years
- All tests include proper setup and cleanup

## Data Flow

### Automatic Data Population
When users save attendance data in "Rekap Absensi" menu:
1. Data is saved to database via `AttendanceStorageService.saveAttendanceData()`
2. Data is stored with key format: `{year}-{month}` (e.g., "2025-05" for May 2025)
3. When Annual Recap is viewed for that year, `AnnualRecapService.getAnnualRecap()`:
   - Queries database for all 12 months of the year
   - Aggregates data per employee
   - Displays in the annual recap table

### Automatic Data Deletion
When users delete data from "Historis Absensi" menu:
1. Data is deleted via `AttendanceStorageService.deleteAttendanceData()`
2. Database record for that month is removed
3. When Annual Recap is viewed next time:
   - The deleted month shows no data ("-" in the cell)
   - The aggregation automatically reflects the deletion
   - No separate cleanup needed

### Key Design Decisions
- **No Data Duplication**: Annual Recap queries existing monthly data, doesn't store separately
- **Reactive by Design**: Always shows current state of database
- **Efficient Queries**: Loads 12 months of data on demand, not continuously
- **Lazy Loading**: Annual Recap data loaded only when screen is opened

## User Experience

### How It Works:
1. User navigates to "Historis Absensi" menu
2. User clicks on a year in the sidebar (e.g., 2025)
3. The year expands to show "Annual Recap" at the top, followed by 12 months
4. User clicks "Annual Recap"
5. The main content area shows a comprehensive table with:
   - All employees (sorted by name)
   - 12 columns for January through December
   - Attendance metrics for each employee-month combination

### Features:
- **Search**: Filter employees by User ID or name
- **Horizontal Scroll**: View all 12 months even on smaller screens
- **Visual Indicators**: Icons and colors differentiate attendance types
- **Empty State Handling**: Clear messages when no data available
- **Responsive Design**: Adapts to different screen sizes

## Technical Notes

### Month Value Convention:
- `month = 0`: Annual Recap
- `month = 1-12`: January through December

### Data Aggregation:
The service aggregates data from `AttendanceSummary` objects:
- `daysMasuk`: Count of days present (from summary.daysMasuk)
- `daysTelat`: Count of days late (from summary.daysTelat)
- `daysLembur`: Count of days with overtime (from summary.daysLembur)

### Performance Considerations:
- Loads all 12 months when screen opens (12 database queries)
- Efficient for typical dataset sizes (dozens of employees)
- Could be optimized with batch queries if needed for larger datasets

## Testing Recommendations

### Manual Testing:
1. Run the app and navigate to "Historis Absensi"
2. Click on a year (e.g., 2024, 2025)
3. Verify "Annual Recap" appears at the top of the month list
4. Click "Annual Recap" and verify:
   - Table shows all employees with data for that year
   - Each month column shows correct attendance counts
   - Search functionality works
   - Empty states display correctly
5. Save new attendance data for a month and verify:
   - Annual Recap immediately reflects the new data
6. Delete attendance data for a month and verify:
   - Annual Recap shows empty cell for that month
7. Test with years that have:
   - No data (empty state)
   - Partial data (some months)
   - Full data (all 12 months)

### Automated Testing:
Run the test suite:
```bash
flutter test test/annual_recap_service_test.dart
```

## Edge Cases Handled

1. **No Data for Year**: Shows empty state with helpful message
2. **New Employees Mid-Year**: Shows only months where employee has data
3. **Deleted Records**: Automatically removed from annual recap view
4. **Partial Month Data**: Shows "-" for months with no data
5. **Search with No Results**: Shows "no results" message
6. **Year with Some Months**: Displays available months, shows "-" for missing ones

## Code Quality
- Follows existing code patterns and style
- Minimal changes to existing code
- No breaking changes
- Backward compatible
- Comprehensive error handling
- Type-safe implementation
- Well-documented code

## Future Enhancement Possibilities

The Annual Recap can be extended with:
- Export to PDF/Excel functionality
- Year-over-year comparison view
- Charts and graphs for trends
- Department-wise filtering
- Expandable rows showing detailed time data
- Summary statistics row (totals, averages)
- Custom date range selection
- Print-friendly layout
