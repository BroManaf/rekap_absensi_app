# Visual Guide: Annual Recap Feature

## Feature Overview
The Annual Recap feature displays a comprehensive yearly view of employee attendance data, showing attendance metrics (days present, days late, days overtime) for all 12 months in a single table.

## Sidebar Structure (Before and After)

### Before (Original):
```
├── 2023
├── 2024 ▼
│   ├── Januari
│   ├── Februari
│   ├── Maret
│   ├── April
│   ├── Mei
│   ├── Juni
│   ├── Juli
│   ├── Agustus
│   ├── September
│   ├── Oktober
│   ├── November
│   └── Desember
├── 2025
└── 2026
```

### After (With Annual Recap):
```
├── 2023
├── 2024 ▼
│   ├── Annual Recap    ← NEW! (Shows yearly summary table)
│   ├── Januari
│   ├── Februari
│   ├── Maret
│   ├── April
│   ├── Mei
│   ├── Juni
│   ├── Juli
│   ├── Agustus
│   ├── September
│   ├── Oktober
│   ├── November
│   └── Desember
├── 2025
└── 2026
```

## Annual Recap Table Layout

### Table Structure:
```
┌─────────────────────┬──────┬──────┬──────┬──────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬──────┐
│ Nama                │ Jan  │ Feb  │ Mar  │ Apr  │ Mei │ Jun │ Jul │ Agu │ Sep │ Okt │ Nov │ Des  │
├─────────────────────┼──────┼──────┼──────┼──────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼──────┤
│ Employee Name 1     │ ✓ 20 │ ✓ 18 │ ✓ 21 │ ✓ 19 │  -  │  -  │  -  │  -  │  -  │  -  │  -  │  -   │
│ (User ID)           │ ⏰ 3 │ ⏰ 2 │ ⏰ 4 │ ⏰ 1 │     │     │     │     │     │     │     │      │
│                     │ 🌙 5 │ 🌙 4 │ 🌙 6 │ 🌙 3 │     │     │     │     │     │     │     │      │
├─────────────────────┼──────┼──────┼──────┼──────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼──────┤
│ Employee Name 2     │ ✓ 18 │ ✓ 20 │  -   │ ✓ 22 │ ... │     │     │     │     │     │     │      │
│ (User ID)           │ ⏰ 2 │ ⏰ 1 │      │ ⏰ 0 │     │     │     │     │     │     │     │      │
│                     │ 🌙 4 │ 🌙 5 │      │ 🌙 7 │     │     │     │     │     │     │     │      │
└─────────────────────┴──────┴──────┴──────┴──────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴──────┘

Legend:
✓ = Days Present (Masuk) - Green check icon
⏰ = Days Late (Telat) - Orange clock icon
🌙 = Days Overtime (Lembur) - Indigo moon icon
- = No data for this month
```

## User Interaction Flow

1. **Initial State**: User sees the sidebar with years (2023-2045)

2. **Click on Year**: Year expands to show "Annual Recap" + 12 months
   - "Annual Recap" appears FIRST (at the top)
   - Then months January through December follow

3. **Click on "Annual Recap"**: 
   - Item becomes highlighted with blue accent
   - Main content area shows full annual recap table with:
     - Header showing "Annual Recap {year}"
     - Search bar to filter employees
     - Horizontally scrollable table with all 12 months
     - Each employee row showing monthly attendance data
     - Employee count indicator

4. **Search Employees**:
   - Type in search box to filter by User ID or name
   - Results update in real-time
   - Clear button (X) to reset search

5. **View Monthly Data**:
   - Scroll horizontally to see all 12 months
   - Each month cell shows three values:
     - Days present (with green check icon)
     - Days late (with orange clock icon)
     - Days overtime (with indigo moon icon)
   - Empty cells show "-" for months with no data

6. **Click on a Regular Month**: Works as before
   - Shows detailed monthly attendance data
   - All existing functionality preserved

## Visual Elements

### Annual Recap Screen Components:

#### Header Section:
- **Title**: "Annual Recap"
  - Font size: 28px
  - Font weight: Bold
  - Color: #1F2937 (dark gray)
- **Subtitle**: "Rekap tahunan karyawan tahun {year}"
  - Font size: 14px
  - Color: Gray 600
- **Employee Count**: "{count} karyawan"
  - Font size: 14px
  - Color: Gray 600
  - Positioned at top right

#### Search Bar:
- **Width**: Max 400px
- **Height**: Standard input height
- **Border**: Gray 300, rounded 8px
- **Border (focused)**: Blue #6366F1, 2px width
- **Background**: Gray 50
- **Placeholder**: "Cari berdasarkan User ID atau Nama..."
- **Icons**:
  - Search icon (left): Gray 400, 20px
  - Clear icon (right, when text present): Gray 400, 18px

#### Table Styling:
- **Container**:
  - Background: White
  - Border radius: 16px
  - Shadow: Subtle (0.05 opacity, 10px blur)
  - Padding: 24px

- **Table Header**:
  - Background: #F8F9FA (light gray)
  - Border bottom: Gray 300, 1px
  - Padding: 12px horizontal, 16px vertical
  - Font weight: 600
  - Font size: 13px
  - Color: Gray 800

- **Employee Name Column**:
  - Width: 200px (fixed)
  - Contains:
    - Employee name (13px, gray 900, medium weight)
    - User ID below (11px, gray 600, normal weight)

- **Month Columns**:
  - Width: 90px each
  - Header: Abbreviated month name (Jan, Feb, etc.)
  - Horizontally scrollable

- **Month Cell (with data)**:
  - Background: Gray 100
  - Border: Gray 300, 1px, rounded 4px
  - Padding: 6px
  - Contains three rows:
    1. Green check icon + days present count
    2. Orange clock icon + days late count
    3. Indigo moon icon + days overtime count
  - Icon size: 10px
  - Text size: 11px
  - Text weight: Medium (500)
  - Text color: Gray 800

- **Month Cell (no data)**:
  - Shows "-" centered
  - Font size: 12px
  - Color: Gray 400
  - No background or border

- **Row Colors**:
  - Even rows: White
  - Odd rows: #FAFAFA (very light gray)
  - Border between rows: Gray 200, 1px

### Annual Recap Item Styling (Sidebar):
- **Background (unselected)**: Transparent
- **Background (selected)**: Light blue (#EEF2FF)
- **Left border (selected)**: Blue accent (#6366F1), 3px width
- **Text color (unselected)**: Gray 600
- **Text color (selected)**: Blue (#6366F1)
- **Font weight (selected)**: Semi-bold (600)
- **Font weight (unselected)**: Normal
- **Padding**: 32px horizontal, 12px vertical
- **Font size**: 14px

### Empty State (No Data for Year):
- **Icon**: Calendar icon (Icons.calendar_today_rounded)
- **Icon size**: 64px
- **Icon color**: Gray 400
- **Title**: "Tidak ada data untuk tahun {year}"
- **Title style**: 18px, gray 600, medium weight
- **Subtitle**: "Belum ada data absensi yang tersimpan untuk tahun ini"
- **Subtitle style**: 14px, gray 400, normal weight

### Empty State (No Year Selected):
- **Icon**: Calendar icon
- **Icon size**: 64px
- **Icon color**: Gray 400
- **Title**: "Pilih tahun dari sidebar"
- **Title style**: 18px, gray 600, medium weight
- **Subtitle**: "Klik tahun di sidebar untuk melihat annual recap"
- **Subtitle style**: 14px, gray 400, normal weight

## Color Scheme

### Primary Colors:
- **Accent Blue**: #6366F1 (for selections, borders)
- **Success Green**: #10B981 (for attendance/masuk icons)
- **Warning Orange**: #F97316 (for late/telat icons)
- **Info Indigo**: #6366F1 (for overtime/lembur icons)

### Background Colors:
- **Page Background**: #F5F5F7
- **Card Background**: White
- **Table Header**: #F8F9FA
- **Odd Row**: #FAFAFA
- **Even Row**: White
- **Cell Background**: Gray 100
- **Input Background**: Gray 50

### Text Colors:
- **Primary**: Gray 900 (#1F2937)
- **Secondary**: Gray 800 (#374151)
- **Tertiary**: Gray 600 (#4B5563)
- **Disabled/Placeholder**: Gray 400 (#9CA3AF)

### Border Colors:
- **Default**: Gray 300 (#D1D5DB)
- **Light**: Gray 200 (#E5E7EB)
- **Accent**: Blue #6366F1

## Code Convention

### Month Value System:
```dart
// Month identifier convention:
annualRecapMonth = 0    // Annual Recap
January = 1             // Januari
February = 2            // Februari
...
December = 12           // Desember
```

### Data Structure:
```dart
// Monthly data for one employee
MonthlyData {
  month: int (1-12)
  daysMasuk: int
  daysTelat: int
  daysLembur: int
  hasData: bool
}

// Annual recap for one employee
EmployeeAnnualRecap {
  employee: Employee
  year: int
  monthlyData: Map<int, MonthlyData>
}
```

### Selection State:
```dart
// Annual Recap selected:
_selectedYear = 2024
_selectedMonth = 0 (annualRecapMonth)

// Monthly view selected:
_selectedYear = 2024
_selectedMonth = 1-12 (January-December)
```

## Responsive Design

### Desktop/Tablet:
- Full table width with horizontal scroll for 12 months
- Search bar constrained to 400px max width
- Table cells show all three metrics with icons

### Mobile (if needed):
- Horizontal scroll essential for viewing all months
- Employee name column remains fixed (sticky)
- May need to adjust column widths for smaller screens
- Consider collapsible/expandable rows for details

## Accessibility

- All interactive elements are keyboard accessible
- Proper focus indicators on search bar and clickable items
- Clear visual feedback on selection
- High contrast text for readability
- Icon + text combination (not relying on color alone)
- Consistent spacing and alignment
- Text labels in Indonesian (primary language)

## Data Flow Visualization

```
┌──────────────────────┐
│  User Actions        │
└──────────┬───────────┘
           │
           ├──► Save Monthly Data (Rekap Absensi)
           │    │
           │    └──► DatabaseService.saveData()
           │         │
           │         └──► Stored as "{year}-{month}"
           │
           ├──► View Annual Recap
           │    │
           │    └──► AnnualRecapService.getAnnualRecap(year)
           │         │
           │         ├──► Load month 1-12 from database
           │         ├──► Aggregate data per employee
           │         └──► Return EmployeeAnnualRecap list
           │              │
           │              └──► Display in table
           │
           └──► Delete Monthly Data (Historis Absensi)
                │
                └──► DatabaseService.deleteData("{year}-{month}")
                     │
                     └──► Next Annual Recap view shows updated data
```

## Performance Considerations

- **Initial Load**: 12 database queries (one per month)
- **Search**: Client-side filtering (no database queries)
- **Scroll**: Horizontal scroll handled by Flutter's ScrollView
- **Updates**: Data loaded on screen open, not continuously
- **Optimization**: Future: Could batch-load all 12 months in single query

## Future Enhancement Possibilities

The Annual Recap can be extended with:
- **Export Functionality**: 
  - Download as Excel file
  - Export as PDF report
  - Print-friendly layout
  
- **Advanced Views**:
  - Expandable rows showing detailed time data
  - Charts and graphs for trends
  - Year-over-year comparison
  - Department-wise filtering
  
- **Analytics**:
  - Summary statistics row (totals, averages, min, max)
  - Attendance percentage per month
  - Trend indicators (up/down arrows)
  - Color-coded cells based on thresholds
  
- **Customization**:
  - Custom date range selection
  - Show/hide specific columns
  - Sort by different metrics
  - Group by department

## Testing Scenarios

### Visual Testing Checklist:
- [ ] Sidebar shows "Annual Recap" at top of year
- [ ] Selection highlight works (blue accent + border)
- [ ] Table displays with proper spacing
- [ ] All 12 month columns visible (scroll to check)
- [ ] Icons display correctly (check, clock, moon)
- [ ] Employee name and ID formatted correctly
- [ ] Empty cells show "-"
- [ ] Row alternating colors work
- [ ] Search bar functions properly
- [ ] Empty states display correctly
- [ ] Responsive behavior on different screen sizes

### Functional Testing Checklist:
- [ ] Annual Recap loads data for correct year
- [ ] Search filters employees correctly
- [ ] Horizontal scroll works smoothly
- [ ] Data updates after saving new month
- [ ] Data updates after deleting month
- [ ] Handles missing months gracefully
- [ ] Handles employees with partial year data
- [ ] Performance acceptable with many employees
- [ ] No errors in console/logs
