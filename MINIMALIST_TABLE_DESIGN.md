# Minimalist Table Design - Detail Information

## Overview
This document describes the implementation of the minimalist table-based design for displaying detail information (rincian keterlambatan, lembur, dan izin/sakit) in the attendance screen.

## Problem Statement
The previous design used card-based layouts with individual rows for each detail entry, which consumed a lot of vertical space and appeared less organized when displaying multiple entries.

## Solution
Redesigned the detail sections to use a compact, minimalist table format that:
- Presents information in a structured, spreadsheet-like layout
- Reduces visual clutter and space consumption
- Maintains all existing information
- Improves readability and aesthetics

## Design Principles

### 1. Minimalism
- **Reduced padding**: 8-12px instead of 12-16px
- **Smaller font sizes**: 12px for content, 14px for headers (down from 13-15px)
- **Compact spacing**: Minimal vertical spacing between rows
- **Clean borders**: Single-line borders instead of multiple card outlines

### 2. Table Structure
Each detail section now uses a proper table format with:
- **Header row**: Column labels with slightly darker background
- **Data rows**: Alternating white/light gray backgrounds for row distinction
- **Consistent columns**: Fixed widths for dates/days, flexible for content

### 3. Information Preservation
All original information is maintained:
- **Late details**: Date, day of week, check-in time, late duration
- **Overtime details**: Date, day of week, check-out time, overtime duration
- **Absence details**: Date, day of week, editable notes field

## Implementation Details

### New Methods

#### `_buildMinimalistTableSection()`
Builds a compact table for late attendance and overtime details.

**Parameters:**
- `title`: Section title (e.g., "Rincian Keterlambatan")
- `icon`: Icon for the section
- `color`: Primary color for the section
- `bgColor`: Background color for table header
- `data`: List of row data (null or empty for no data)
- `headers`: List of column headers ['Tgl', 'Hari', 'Jam Masuk', 'Durasi']
- `emptyMessage`: Message to display when no data

**Features:**
- Colored header row matching the section theme
- Alternating row colors (white/light gray)
- Compact 12px font size for data
- Fixed-width columns for dates and durations
- Rounded corners on table borders

#### `_buildAbsenceTableSection()`
Builds a compact table for absence/sick leave details with editable notes.

**Parameters:**
- `title`: Section title ("Rincian Izin/Sakit")
- `icon`: Icon for the section
- `color`: Primary color for the section
- `absenceDetails`: List of absence records

**Features:**
- Inline text fields for editing notes
- Compact layout with integrated input fields
- Same alternating row pattern
- Smaller, more compact form fields

### Column Layout

#### Late/Overtime Tables
| Column | Width | Alignment | Content |
|--------|-------|-----------|---------|
| Tgl (Date) | 40px | Left | Day number only (e.g., "15") |
| Hari (Day) | 50px | Left | Day abbreviation (e.g., "Sen") |
| Jam (Time) | Flexible | Left | Time in HH:MM format |
| Durasi (Duration) | 60px | Right | Duration in "Xh Ym" format |

#### Absence Table
| Column | Width | Alignment | Content |
|--------|-------|-----------|---------|
| Tgl (Date) | 40px | Left | Day number only |
| Hari (Day) | 50px | Left | Day abbreviation |
| Keterangan | Flexible | Left | Editable text field for notes |

### Color Scheme

#### Late Details (Orange Theme)
- Header background: `Colors.orange[50]` (light orange)
- Border: `Colors.grey[300]`
- Text: `Colors.grey[700]` - `Colors.grey[900]`

#### Overtime Details (Indigo Theme)
- Header background: `Colors.indigo[50]` (light indigo)
- Border: `Colors.grey[300]`
- Text: `Colors.grey[700]` - `Colors.grey[900]`

#### Absence Details (Red Theme)
- Header background: `Colors.red[50]` (light red)
- Border: `Colors.grey[300]`
- Text: `Colors.grey[700]` - `Colors.grey[900]`

### Empty State
When there is no data for a section:
- Light gray background (`Colors.grey[50]`)
- Check icon with message
- Compact single-line layout
- Consistent with overall minimalist design

## Comparison: Before vs After

### Before (Card-Based Layout)
```
┌─────────────────────────────────────────┐
│ Tanggal 15 (Sen)                        │
│ Masuk jam 08:15                         │
│                               Telat: 15m│
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ Tanggal 16 (Sel)                        │
│ Masuk jam 08:30                         │
│                               Telat: 30m│
└─────────────────────────────────────────┘
```

### After (Table Layout)
```
┌────┬──────┬───────────┬─────────┐
│ Tgl│ Hari │ Jam Masuk │  Durasi │
├────┼──────┼───────────┼─────────┤
│ 15 │ Sen  │ 08:15     │     15m │
│ 16 │ Sel  │ 08:30     │     30m │
└────┴──────┴───────────┴─────────┘
```

### Space Savings
- **Vertical space**: ~60% reduction per entry
- **Visual clutter**: Significantly reduced with single table border
- **Readability**: Improved with structured columns

## Typography

### Header Row
- Font weight: 600 (Semi-bold)
- Font size: 12px
- Color: `Colors.grey[700]`

### Data Rows
- Font weight: Normal (400) for most content, 500 for dates, 600 for durations
- Font size: 12px
- Color: `Colors.grey[700]` - `Colors.grey[900]`

### Section Titles
- Font weight: 600 (Semi-bold)
- Font size: 14px (down from 15px)
- Icon size: 16px (down from 18px)

## Accessibility Features

### Visual Hierarchy
- Clear section titles with icons
- Header row visually distinct from data rows
- Alternating row colors for easy scanning

### Interactive Elements
- Text fields maintain appropriate touch target size
- Focus indicators on input fields
- Proper label associations

## Technical Implementation

### Widget Structure
```
_buildDetailView()
├── _buildMinimalistTableSection() [Late details]
│   ├── Section Title (Icon + Text)
│   └── Table or Empty State
│       ├── Header Row (colored background)
│       └── Data Rows (alternating colors)
├── _buildMinimalistTableSection() [Overtime details]
│   └── [Same structure as above]
└── _buildAbsenceTableSection() [Absence details]
    ├── Section Title (Icon + Text)
    └── Table or Empty State
        ├── Header Row (colored background)
        └── Data Rows with inline TextField
```

### Key Widgets Used
- `Container`: For borders, backgrounds, and padding
- `Row`: For horizontal column layout
- `Column`: For vertical table structure
- `SizedBox`: For fixed column widths
- `Expanded`: For flexible columns
- `TextField`: For editable absence notes
- `BoxDecoration`: For styling and rounded corners

## Benefits

### User Experience
✅ **More information visible at once**: Reduced scrolling needed
✅ **Easier to scan**: Table format natural for reading data
✅ **Cleaner appearance**: Less visual noise and clutter
✅ **Professional look**: Spreadsheet-like presentation

### Developer Experience
✅ **Maintainable code**: Clear separation of concerns
✅ **Reusable components**: Table builder can be used for other sections
✅ **Type-safe**: Proper data structure with Maps
✅ **Well-documented**: Clear parameter names and comments

### Performance
✅ **Efficient rendering**: Fewer widget trees per entry
✅ **Lower memory**: Less padding and decoration overhead
✅ **Faster layout**: Simpler widget hierarchy

## Future Enhancements (Optional)

### Potential Improvements
- [ ] Sort table by clicking column headers
- [ ] Filter/search within detail tables
- [ ] Export individual tables to CSV
- [ ] Pagination for tables with many entries
- [ ] Collapsible/expandable table sections
- [ ] Column width customization
- [ ] Print-optimized table view

### A11y Enhancements
- [ ] Screen reader optimizations
- [ ] Keyboard navigation for table cells
- [ ] High contrast mode support
- [ ] Larger touch targets option

## Migration Notes

### Removed Methods
The following methods were removed and replaced with the new table-based methods:
- `_buildDetailSection()` - Generic section builder
- `_buildDetailRow()` - Individual card-style row
- `_buildEmptyState()` - Standalone empty state card
- `_buildAbsenceRow()` - Card-style absence row with notes

### Breaking Changes
None. This is a visual redesign with no changes to:
- Data models
- Service layer
- API contracts
- State management
- External interfaces

## Conclusion

The minimalist table design successfully achieves the goal of making detail information more neat, organized, and space-efficient while preserving all functionality and improving the overall user experience. The design is consistent with modern UI/UX principles and provides a professional, clean appearance appropriate for an attendance management application.
