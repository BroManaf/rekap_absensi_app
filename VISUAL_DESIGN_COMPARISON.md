# Visual Design Comparison

## Before (ExpansionTile Accordion)

```
┌─────────────────────────────────────────────────────────────┐
│  Card with Shadow                                            │
│  ┌────┐                                                      │
│  │ 1  │  Employee Name                [Stats in columns]    │
│  └────┘  [UserID Badge] [Dept Badge]  Masuk | Telat | Lembur│
│          ▼ (Expansion Icon)                                  │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  Card with Shadow                                            │
│  ┌────┐                                                      │
│  │ 2  │  Employee Name                [Stats in columns]    │
│  └────┘  [UserID Badge] [Dept Badge]  Masuk | Telat | Lembur│
│          ▼ (Expansion Icon)                                  │
└─────────────────────────────────────────────────────────────┘
```

**Issues:**
- Cards create visual separation (floating effect)
- Less table-like appearance
- Number shown in circular avatar
- Stats appear as part of the card title
- Expansion icon is built into ExpansionTile

---

## After (Expandable Table)

```
┌──────────────────────────────────────────────────────────────────────────┐
│ TABLE HEADER (Light Gray Background #F8F9FA)                             │
├──────┬────┬──────────────┬─────────┬──────────┬───────┬───────┬─────────┤
│ Icon │ No │ Nama Karyawan│ User ID │Department│ Masuk │ Telat │ Lembur  │
├──────┼────┼──────────────┼─────────┼──────────┼───────┼───────┼─────────┤
│  ►   │ 1  │ Employee Name│[Badge]  │ [Badge]  │  ⏰   │  ⚠️  │  🌙    │
│      │    │              │         │          │ 10h/3 │ 2h/2  │ 5h/1    │
├──────┼────┼──────────────┼─────────┼──────────┼───────┼───────┼─────────┤
│  ▼   │ 2  │ Employee Name│[Badge]  │ [Badge]  │  ⏰   │  ⚠️  │  🌙    │ (Expanded)
│      │    │              │         │          │ 12h/4 │ 1h/1  │ 3h/1    │
├──────┴────┴──────────────┴─────────┴──────────┴───────┴───────┴─────────┤
│  DETAIL SECTION (Expanded Content)                                       │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │ 📋 Rincian Keterlambatan                                        │    │
│  │   • Tanggal 1 (Sen) - Masuk jam 08:30 - Telat: 30m             │    │
│  │                                                                  │    │
│  │ 📋 Rincian Lembur                                               │    │
│  │   • Tanggal 5 (Jum) - Pulang jam 19:00 - Lembur: 2h            │    │
│  │                                                                  │    │
│  │ 📋 Rincian Izin/Sakit                                           │    │
│  │   (No absence records)                                          │    │
│  └─────────────────────────────────────────────────────────────────┘    │
├──────┬────┬──────────────┬─────────┬──────────┬───────┬───────┬─────────┤
│  ►   │ 3  │ Employee Name│[Badge]  │ [Badge]  │  ⏰   │  ⚠️  │  🌙    │
│      │    │              │         │          │ 8h/2  │ 0h/0  │ 4h/2    │
└──────┴────┴──────────────┴─────────┴──────────┴───────┴───────┴─────────┘
```

**Improvements:**
- ✅ Clean table structure with clear columns
- ✅ No card shadows - flat, minimalist design
- ✅ Alternating row colors (white/light gray) for readability
- ✅ Chevron icon (►/▼) that rotates on expand
- ✅ Table header with column labels
- ✅ Icons directly in table cells
- ✅ Hover effects on rows
- ✅ Professional spreadsheet-like appearance
- ✅ Smooth animations (200ms rotation, 300ms expansion)

---

## Key Visual Differences

### Layout
| Feature | Before (Accordion) | After (Table) |
|---------|-------------------|---------------|
| Structure | Cards with gaps | Continuous table |
| Separator | Card margins | Subtle borders |
| Background | White cards + gray page | Alternating rows |
| Visual Weight | Heavy (shadows) | Light (borders) |

### Headers
| Feature | Before | After |
|---------|--------|-------|
| Column Labels | None | Clear header row |
| Visual Hierarchy | Implicit | Explicit |

### Interaction
| Feature | Before | After |
|---------|--------|-------|
| Expand Icon | Built-in ▼ | Custom animated ► |
| Hover | None | Light gray highlight |
| Click Target | ExpansionTile | Entire row |
| Animation | Default | Custom 300ms |

### Typography & Spacing
| Feature | Before | After |
|---------|--------|-------|
| Employee Name | 16px bold | 14px bold |
| Badges | Same | Same (kept consistent) |
| Stats Display | Vertical with label | Horizontal with icon |
| Row Height | Variable | Consistent |
| Padding | 16px/8px | 16px/14px |

---

## Color Palette

### Table Structure
- **Header Background**: `#F8F9FA` (very light gray)
- **Even Rows**: `#FFFFFF` (white)
- **Odd Rows**: `#FAFAFA` (off-white)
- **Hover**: `#F3F4F6` (light gray)
- **Expanded Section**: `#F9FAFB` (slightly gray)
- **Borders**: Gray 200-300

### Status Indicators
- **Check-in (Masuk)**: Green 600-700
- **Late (Telat)**: Orange 600-700
- **Overtime (Lembur)**: Indigo 600-700
- **Absence**: Red 600-700

### Badges
- **User ID**: Blue 50 bg / Blue 700 text
- **Department**: Purple 50 bg / Purple 700 text

---

## Animations

### Chevron Icon Rotation
```dart
AnimatedRotation(
  duration: Duration(milliseconds: 200),
  turns: isExpanded ? 0.25 : 0.0,  // 0° → 90°
  child: Icon(Icons.chevron_right)
)
```

### Content Expansion
```dart
AnimatedSize(
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  child: isExpanded ? content : SizedBox.shrink()
)
```

---

## Responsive Behavior

### Column Flex Ratios
- Icon: Fixed 40px
- No: Fixed 50px
- Name: flex 2 (largest)
- User ID: flex 1
- Department: flex 1
- Masuk: flex 1
- Telat: flex 1
- Lembur: flex 1

This ensures proper space distribution across different screen sizes while maintaining readability.
