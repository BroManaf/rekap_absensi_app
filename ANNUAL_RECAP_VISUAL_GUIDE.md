# Visual Guide: Annual Recap Feature

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
│   ├── Annual Recap    ← NEW!
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

## User Interaction Flow

1. **Initial State**: User sees the sidebar with years (2023-2045)

2. **Click on Year**: Year expands to show "Annual Recap" + 12 months
   - "Annual Recap" appears FIRST (at the top)
   - Then months January through December follow

3. **Click on "Annual Recap"**: 
   - Item becomes highlighted with blue accent
   - Main content area updates to show:
     - Header: "Annual Recap 2024"
     - Empty state icon (calendar icon)
     - Message: "Annual Recap 2024"
     - Subtitle: "Konten Annual Recap belum tersedia"

4. **Click on a Month**: Works as before
   - Shows monthly attendance data
   - All existing functionality preserved

## Visual Elements

### Annual Recap Item Styling:
- **Background (unselected)**: Transparent
- **Background (selected)**: Light blue (#EEF2FF)
- **Left border (selected)**: Blue accent (#6366F1), 3px width
- **Text color (unselected)**: Gray (#757575)
- **Text color (selected)**: Blue (#6366F1)
- **Font weight (selected)**: Semi-bold (600)
- **Padding**: 32px horizontal, 12px vertical
- **Font size**: 14px

### Empty State for Annual Recap:
- **Icon**: Calendar icon (Icons.calendar_today_rounded)
- **Icon size**: 64px
- **Icon color**: Gray 400
- **Title**: "Annual Recap {year}"
- **Title style**: 18px, gray 600, medium weight
- **Subtitle**: "Konten Annual Recap belum tersedia"
- **Subtitle style**: 14px, gray 400, normal weight

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

### Selection State:
```dart
// Annual Recap selected:
_selectedYear = 2024
_selectedMonth = 0 (annualRecapMonth)

// Monthly view selected:
_selectedYear = 2024
_selectedMonth = 1-12 (January-December)
```

## Accessibility

- All items are clickable (InkWell with tap handler)
- Visual feedback on hover (hover color)
- Clear selection state with color and border
- Text labels in Indonesian (primary language)
- Consistent spacing and alignment

## Future Enhancement Possibilities

When content is ready to be added to Annual Recap, the empty state can be replaced with:
- Annual summary statistics table
- Year-over-year comparison charts
- Total attendance metrics for the year
- Department-wise annual reports
- Download annual report button
- Etc.

The infrastructure is now in place to support any content in the Annual Recap view.
