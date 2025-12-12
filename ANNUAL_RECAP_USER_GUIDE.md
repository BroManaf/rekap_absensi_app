# Annual Recap Feature - Quick Start Guide

## What is Annual Recap?

Annual Recap is a new feature that displays a comprehensive yearly view of employee attendance data. It shows attendance metrics (days present, days late, days overtime) for all 12 months in a single table, making it easy to see attendance patterns throughout the year.

## How to Access

1. Open the application
2. Navigate to **"Historis Absensi"** in the main sidebar (second icon from top)
3. Click on any **year** in the secondary sidebar (e.g., 2024, 2025)
4. Click on **"Annual Recap"** at the top of the expanded year menu
5. The annual recap table will display showing all employees with data for that year

## What You'll See

### Annual Recap Table

```
┌─────────────────────┬──────┬──────┬──────┬─────────┬──────┐
│ Nama                │ Jan  │ Feb  │ Mar  │   ...   │ Des  │
├─────────────────────┼──────┼──────┼──────┼─────────┼──────┤
│ Irfan Manaf         │ ✓ 20 │ ✓ 18 │ ✓ 21 │         │ ✓ 19 │
│ EMP001              │ ⏰ 3 │ ⏰ 2 │ ⏰ 4 │         │ ⏰ 1 │
│                     │ 🌙 5 │ 🌙 4 │ 🌙 6 │         │ 🌙 3 │
└─────────────────────┴──────┴──────┴──────┴─────────┴──────┘
```

Each month cell shows three numbers:
- **✓ Green check icon**: Days present (masuk)
- **⏰ Orange clock icon**: Days late (telat)
- **🌙 Indigo moon icon**: Days overtime (lembur)
- **-**: No data for that month

### Features

- **Search**: Use the search bar to filter employees by User ID or name
- **Horizontal Scroll**: Scroll left/right to view all 12 months
- **Empty States**: Clear messages when no data is available

## How Data is Updated

### Automatic Population
When you save attendance data in "Rekap Absensi" menu:
1. Upload and save Excel file for a specific month (e.g., May 2025)
2. The data is automatically stored in the database
3. Go to Annual Recap 2025
4. May column will show the attendance data for all employees

**No manual action needed!** The data automatically appears in Annual Recap.

### Automatic Deletion
When you delete data from "Historis Absensi" menu:
1. Click "Hapus Data" for a specific month (e.g., May 2025)
2. Confirm the deletion
3. The data is removed from the database
4. Go to Annual Recap 2025
5. May column will now show "-" (no data)

**No manual action needed!** The deletion automatically updates Annual Recap.

## Use Cases

### 1. Yearly Attendance Review
Quickly see which employees had consistent attendance throughout the year and which months had issues.

### 2. Performance Evaluation
Review overtime patterns across the year to identify high-performing employees or periods of high workload.

### 3. Attendance Trends
Identify months with high lateness rates to investigate potential causes.

### 4. Employee Comparison
Compare attendance patterns between multiple employees side-by-side.

### 5. Data Verification
Verify that all months have data saved, or identify which months are missing.

## Tips

1. **Use Search**: When you have many employees, use the search bar to quickly find specific individuals.

2. **Check Multiple Years**: Compare Annual Recaps from different years to see trends over time.

3. **Empty Cells**: If you see "-" in a cell, it means no attendance data was saved for that employee-month combination. Either:
   - The data was never uploaded
   - The data was deleted
   - The employee wasn't working that month

4. **Horizontal Scroll**: On smaller screens, scroll horizontally to see all 12 months. The employee name column stays fixed on the left.

5. **Data Accuracy**: The Annual Recap always shows the current state of the database. There's no caching or outdated data.

## Troubleshooting

### "Tidak ada data untuk tahun [year]"
This means no attendance data has been saved for any month of that year yet.
- **Solution**: Save attendance data for at least one month of that year via "Rekap Absensi" menu.

### Employee not appearing in Annual Recap
The employee only appears if they have data for at least one month of the selected year.
- **Solution**: Ensure the employee's attendance data has been saved for at least one month.

### Month column shows "-"
No data exists for that employee-month combination.
- **Solution**: Upload and save attendance data for that month if it should have data.

### Can't find an employee
Use the search bar at the top of the table.
- **Solution**: Type the employee's User ID or name in the search box.

## Technical Details

### Data Source
Annual Recap queries the existing monthly attendance records from the database. It does NOT store data separately, ensuring data consistency.

### Performance
- Loads data for all 12 months when the Annual Recap screen is opened
- Suitable for typical employee counts (dozens to hundreds)
- Search filtering is done in memory for instant results

### Data Integrity
- Annual Recap always reflects the current state of the database
- No manual synchronization needed
- Deleting monthly data automatically updates Annual Recap
- Adding monthly data automatically populates Annual Recap

## Example Workflow

### Scenario: Reviewing Employee Attendance for 2024

1. **Navigate to Annual Recap**:
   - Click "Historis Absensi"
   - Click "2024"
   - Click "Annual Recap"

2. **Review Overall Attendance**:
   - Scroll through the table to see all employees
   - Look for patterns (consistent attendance, high overtime, frequent lateness)

3. **Focus on Specific Employee**:
   - Type employee name in search bar
   - Review their monthly data across the year

4. **Check Data Completeness**:
   - Look for months showing "-"
   - If data is missing, upload it via "Rekap Absensi" menu

5. **Compare with Previous Year** (optional):
   - Click "2023" → "Annual Recap"
   - Compare trends year-over-year

## Benefits

✅ **Time-Saving**: See entire year at a glance instead of checking 12 individual months

✅ **Data-Driven**: Make informed decisions based on yearly attendance patterns

✅ **Always Current**: No need to refresh or rebuild reports - data updates automatically

✅ **Easy to Use**: Simple table interface with search functionality

✅ **Comprehensive**: See all attendance metrics (present, late, overtime) in one place

✅ **Reliable**: No data duplication or synchronization issues

## Support

For more detailed information, see:
- **ANNUAL_RECAP_IMPLEMENTATION.md** - Technical implementation details
- **ANNUAL_RECAP_VISUAL_GUIDE.md** - Visual design specifications
- **ANNUAL_RECAP_COMPLETE.md** - Complete implementation summary

## Feedback

If you encounter any issues or have suggestions for improvements, please report them to the development team.
