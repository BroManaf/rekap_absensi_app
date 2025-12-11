# Expandable Table View Implementation

## Overview
This document describes the implementation of the expandable table view for the attendance screen, replacing the previous ExpansionTile-based accordion design with a minimalist, elegant table layout.

## Changes Made

### 1. State Management
- Added `_expandedRows` Set to track which rows are currently expanded
- Each row can be independently expanded/collapsed by clicking

### 2. Table Structure

#### Header Row
- Fixed header with clear column labels:
  - No (row number)
  - Nama Karyawan (Employee Name)
  - User ID
  - Department
  - Masuk (Check-in time)
  - Telat (Late time)
  - Lembur (Overtime)
- Styled with light gray background (`#F8F9FA`)
- Bold font for clear hierarchy

#### Data Rows
- Alternating row colors for better readability:
  - Even rows: White background
  - Odd rows: Light gray background (`#FAFAFA`)
- Hover effect: Light gray (`#F3F4F6`)
- Clickable rows to expand/collapse
- Smooth border separation between rows

### 3. Visual Indicators

#### Expand/Collapse Icon
- Chevron icon (►) positioned at the start of each row
- Animated rotation when expanding (0° → 90°)
- Animation duration: 200ms
- Smooth and responsive

### 4. Expanded Detail View

#### Animation
- AnimatedSize widget for smooth expansion/collapse
- Duration: 300ms
- Curve: easeInOut for natural motion

#### Styling
- White background with subtle border
- Enhanced detail sections for:
  - Late attendance details (orange theme)
  - Overtime details (indigo theme)
  - Absence/sick leave details (red theme)
- Each section with icons and color-coded information
- Improved spacing and padding for better readability

### 5. Color Scheme

#### Primary Colors
- Header: `#F8F9FA` (light gray)
- Even rows: White
- Odd rows: `#FAFAFA` (very light gray)
- Expanded section: `#F9FAFB` (slightly off-white)
- Hover: `#F3F4F6` (light gray)

#### Status Colors
- Success/Check-in: Green (`green[600]`, `green[700]`)
- Warning/Late: Orange (`orange[600]`, `orange[700]`)
- Info/Overtime: Indigo (`indigo[600]`, `indigo[700]`)
- Error/Absence: Red (`red[600]`, `red[700]`)

#### Badge Colors
- User ID: Blue background (`blue[50]`) with blue text (`blue[700]`)
- Department: Purple background (`purple[50]`) with purple text (`purple[700]`)

### 6. Typography
- Header: Font weight 600, size 13px
- Row number: Font weight 500, size 14px
- Employee name: Font weight 600, size 14px
- Badges: Font weight 500, size 12px
- Stats: Font weight 600, size 13px
- Details: Font size 13px

### 7. Layout & Spacing
- Horizontal padding: 16px
- Vertical padding: 12px (header), 14px (rows)
- Icon size: 14-20px depending on context
- Consistent spacing between elements (8px gaps)
- Flexible column widths with proper flex ratios

## Key Features

### Minimalist Design
✅ Clean table layout without excessive borders or shadows
✅ Subtle color variations for visual separation
✅ Focus on content with minimal decorative elements

### Elegant Interactions
✅ Smooth animations for expand/collapse
✅ Hover feedback on rows
✅ Rotating chevron icon
✅ Professional and polished feel

### Responsive Layout
✅ Flexible column widths that adapt to content
✅ Proper text wrapping and alignment
✅ Consistent spacing across different screen sizes

### Enhanced Readability
✅ Alternating row colors
✅ Clear visual hierarchy
✅ Color-coded status indicators
✅ Well-organized detail sections

## Migration from ExpansionTile

### Before (ExpansionTile)
- Card-based layout with elevation
- ExpansionTile widget with automatic expansion
- Less control over animations
- More "accordion" feel

### After (Custom Table)
- Table-based layout without cards
- Custom expand/collapse logic
- Full control over animations and transitions
- Clean "spreadsheet" feel

## Technical Implementation

### Widget Hierarchy
```
Column
├── Container (Header)
│   └── Row (Header columns)
└── ListView.builder
    └── _buildExpandableTableRow (for each employee)
        └── Column
            ├── InkWell (Clickable row)
            │   └── Container
            │       └── Row (Data columns)
            └── AnimatedSize (Detail section)
                └── Container
                    └── _buildDetailView
```

### Animation Details
1. **Chevron rotation**: AnimatedRotation with 200ms duration
2. **Row expansion**: AnimatedSize with 300ms duration and easeInOut curve
3. **Hover effect**: Built-in InkWell ripple effect

## Future Enhancements (Optional)
- [ ] Sort columns by clicking headers
- [ ] Search/filter functionality
- [ ] Export selected rows
- [ ] Pagination for large datasets
- [ ] Column width customization
- [ ] Bulk expand/collapse all rows
