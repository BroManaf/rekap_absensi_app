# Search Feature - Visual UI Guide

## UI Layout

```
┌────────────────────────────────────────────────────────────────┐
│ Rekap Absensi                                     50 karyawan  │
│ File: attendance_data.xlsx                      [Upload Baru]  │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│ ┌──────────────────────────────────────────────────────────┐  │
│ │ 🔍 Cari berdasarkan User ID atau Nama Karyawan...    [X]│  │ ← SEARCH FIELD
│ └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│ Menampilkan 3 dari 50 karyawan                                │ ← FEEDBACK
│                                                                 │
├────────────────────────────────────────────────────────────────┤
│ User ID │ Nama Karyawan      │ Masuk  │ Telat │ Lembur       │ ← TABLE HEADER
├────────────────────────────────────────────────────────────────┤
│ 1234    │ Budi Santoso       │ 150h   │ 2h    │ 10h          │
│         │ Dept: Office       │        │       │              │
├────────────────────────────────────────────────────────────────┤
│ 1235    │ Budiman Ahmad      │ 148h   │ 1h    │ 5h           │
│         │ Dept: Staff        │        │       │              │
├────────────────────────────────────────────────────────────────┤
│ 5678    │ Budi Prasetyo      │ 152h   │ 0h    │ 12h          │
│         │ Dept: Quarry       │        │       │              │
└────────────────────────────────────────────────────────────────┘
```

## Search States

### State 1: Empty Search (Default)
```
┌──────────────────────────────────────────────────────────┐
│ 🔍 Cari berdasarkan User ID atau Nama Karyawan...      │
└──────────────────────────────────────────────────────────┘

→ Shows all 50 employees
→ No clear button visible
```

### State 2: Typing / Filtering
```
┌──────────────────────────────────────────────────────────┐
│ 🔍 bud                                              [X] │
└──────────────────────────────────────────────────────────┘

Menampilkan 3 dari 50 karyawan

→ Shows 3 filtered results
→ Clear button [X] appears
→ Feedback message shows count
```

### State 3: No Results
```
┌──────────────────────────────────────────────────────────┐
│ 🔍 xyz999                                           [X] │
└──────────────────────────────────────────────────────────┘

⚠ Tidak ada hasil yang cocok dengan pencarian "xyz999"

→ Empty table
→ Warning message in orange
→ Clear button [X] visible
```

### State 4: Focused (User is typing)
```
┌──────────────────────────────────────────────────────────┐
│ 🔍 ahmad                                            [X] │ ← Blue border
└──────────────────────────────────────────────────────────┘

Menampilkan 5 dari 50 karyawan

→ Blue focus border (indigo #6366F1)
→ Real-time filtering as user types
```

## Component Specifications

### Search TextField
```
┌─────────────────────────────────────────────────┐
│ [Icon] [Input Text]                      [Icon] │
│   🔍     User input here                   X    │
└─────────────────────────────────────────────────┘
```

**Properties:**
- Width: max 400px
- Height: auto (content padding 12px vertical)
- Background: #F9FAFB (light grey)
- Border: #D1D5DB (grey 300)
- Focus Border: #6366F1 (indigo, 2px)
- Border Radius: 8px
- Font Size: 14px

**Icons:**
- Prefix: Search icon (size 20px, grey 400)
- Suffix: Clear icon (size 20px, grey 400, conditional)

### Feedback Messages

**Success State:**
```
ℹ️ Menampilkan 3 dari 50 karyawan
```
- Color: Grey 600 (#6B7280)
- Font Size: 13px
- Margin Top: 12px

**No Results State:**
```
⚠️ Tidak ada hasil yang cocok dengan pencarian "xyz999"
```
- Color: Orange 700 (#C2410C)
- Font Size: 13px
- Margin Top: 12px

## Interaction Flow

```
┌─────────────┐
│ User opens  │
│ attendance  │
│   screen    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│Upload Excel │
│    file     │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  Data loaded    │
│ Table displayed │
│ Search visible  │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌────────┐ ┌──────────┐
│ Type   │ │ Click    │
│ in     │ │ clear    │
│ search │ │ button   │
└───┬────┘ └────┬─────┘
    │           │
    ▼           ▼
┌────────┐  ┌────────┐
│Results │  │ Reset  │
│filtered│  │ search │
└────────┘  └────────┘
```

## Responsive Behavior

### Desktop (>800px)
```
┌───────────────────────────────────────────────────────────┐
│ Search Field: 400px max-width, left-aligned               │
│ Table: Full width with all columns                        │
└───────────────────────────────────────────────────────────┘
```

### Tablet (600-800px)
```
┌─────────────────────────────────────────────┐
│ Search Field: Adaptive width                │
│ Table: May have scrolling                   │
└─────────────────────────────────────────────┘
```

### Mobile (<600px)
```
┌───────────────────────────┐
│ Search Field: Full width  │
│ Table: Horizontal scroll  │
└───────────────────────────┘
```

## Color Palette

```
Background Colors:
- Search Field: #F9FAFB (grey 50)
- Table Header: #F8F9FA (light grey)
- Even Rows: #FFFFFF (white)
- Odd Rows: #FAFAFA (off-white)

Border Colors:
- Default: #D1D5DB (grey 300)
- Focus: #6366F1 (indigo)

Text Colors:
- Primary: #111827 (grey 900)
- Secondary: #6B7280 (grey 600)
- Tertiary: #9CA3AF (grey 400)
- Warning: #C2410C (orange 700)
- Success: #15803D (green 700)

Icon Colors:
- Default: #9CA3AF (grey 400)
- Hover: #6B7280 (grey 600)
```

## Animation

### Search Clear Button
```
Appear: Fade in (300ms)
Disappear: Fade out (300ms)
```

### Focus State
```
Border transition: 200ms ease-in-out
Color: grey → indigo
Width: 1px → 2px
```

### Filter Results
```
Update: Instant (no animation)
Reason: Better UX for real-time search
```

## Accessibility

1. **Label**: "Cari berdasarkan User ID atau Nama Karyawan..."
2. **Keyboard**: Full keyboard navigation support
3. **Screen Reader**: TextField announces changes
4. **Focus Visible**: Clear focus indicator (blue border)
5. **Clear Button**: Accessible with keyboard (Tab + Enter)

## Example Code Structure

```dart
// Search UI Component
Container(
  constraints: BoxConstraints(maxWidth: 400),
  child: TextField(
    controller: _searchController,
    decoration: InputDecoration(
      hintText: 'Cari berdasarkan User ID atau Nama Karyawan...',
      prefixIcon: Icon(Icons.search),
      suffixIcon: _searchQuery.isNotEmpty 
        ? IconButton(icon: Icon(Icons.clear), onPressed: clearSearch)
        : null,
      // ... styling
    ),
    onChanged: (value) => setState(() => _searchQuery = value),
  ),
)

// Feedback Message
if (_searchQuery.isNotEmpty && _filteredSummaries.isEmpty)
  Text('Tidak ada hasil yang cocok dengan pencarian "$_searchQuery"')

if (_searchQuery.isNotEmpty && _filteredSummaries.isNotEmpty)
  Text('Menampilkan ${_filteredSummaries.length} dari ${_summaries.length} karyawan')
```

## Testing Checklist

Visual Tests:
- [ ] Search field displays correctly
- [ ] Search icon visible on left
- [ ] Clear button appears when typing
- [ ] Focus border changes to blue
- [ ] Feedback messages display correctly
- [ ] Table filters in real-time
- [ ] Empty state shows warning message

Functional Tests:
- [ ] Type in search → filters results
- [ ] Click clear → resets search
- [ ] Case-insensitive search works
- [ ] Partial matching works
- [ ] User ID search works
- [ ] Name search works
- [ ] Upload new file → resets search

Edge Cases:
- [ ] Search with special characters
- [ ] Search with numbers
- [ ] Search with spaces
- [ ] Very long search query
- [ ] Rapid typing
