# Developer Guide: Expandable Table Implementation

## Quick Reference

### Key Files Modified
- `lib/screens/attendance_screen.dart` - Main implementation

### New State Variables
```dart
final Set<int> _expandedRows = {};  // Tracks which rows are expanded
```

### Methods Added
- `_buildExpandableTableRow()` - Builds individual table rows with expand functionality

### Methods Modified
- `_buildSummaryTable()` - Changed from ListView to Column with header + ListView

### Methods Removed
- `_buildEmployeeCard()` - Old ExpansionTile-based card (no longer needed)
- `_buildStat()` - Helper for old card stats (no longer needed)

---

## Implementation Details

### 1. Table Header

**Location:** `_buildSummaryTable()` method

**Structure:**
```dart
Container(
  decoration: BoxDecoration(
    color: Color(0xFFF8F9FA),  // Light gray background
    border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
  ),
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Row(
    children: [
      SizedBox(width: 40),  // Space for expand icon
      SizedBox(width: 50, child: Text('No')),
      Expanded(flex: 2, child: Text('Nama Karyawan')),
      Expanded(flex: 1, child: Text('User ID')),
      Expanded(flex: 1, child: Text('Department')),
      Expanded(flex: 1, child: Text('Masuk', textAlign: TextAlign.center)),
      Expanded(flex: 1, child: Text('Telat', textAlign: TextAlign.center)),
      Expanded(flex: 1, child: Text('Lembur', textAlign: TextAlign.center)),
    ],
  ),
)
```

**Key Points:**
- Fixed 40px space at start for expand icon alignment
- Fixed 50px width for row numbers
- Flex ratios: Name (2), others (1 each)
- Center-aligned stats columns

---

### 2. Expandable Row State Management

**How it works:**
1. Click on any row triggers `setState()`
2. `_expandedRows` Set is checked/updated
3. Row rebuilds with new expanded state
4. AnimatedSize smoothly shows/hides detail section

**Code:**
```dart
InkWell(
  onTap: () {
    setState(() {
      if (isExpanded) {
        _expandedRows.remove(index);
      } else {
        _expandedRows.add(index);
      }
    });
  },
  // ... row content
)
```

**Why use a Set?**
- Fast O(1) lookup with `contains(index)`
- Automatic duplicate prevention
- Multiple rows can be expanded simultaneously

---

### 3. Row Visual Design

**Alternating Colors:**
```dart
final isEven = index % 2 == 0;
color: isEven ? Colors.white : const Color(0xFFFAFAFA)
```

**Hover Effect:**
```dart
InkWell(
  hoverColor: const Color(0xFFF3F4F6),
  // ... content
)
```

**Border Separation:**
```dart
border: Border(
  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
)
```

---

### 4. Animated Chevron Icon

**Implementation:**
```dart
AnimatedRotation(
  duration: const Duration(milliseconds: 200),
  turns: isExpanded ? 0.25 : 0.0,  // 0° or 90°
  child: Icon(
    Icons.chevron_right,
    size: 20,
    color: Colors.grey[600],
  ),
)
```

**Explanation:**
- `turns` uses rotation as fraction of 360°
- `0.25` = 90° (quarter turn)
- `0.0` = 0° (pointing right)
- Rotates clockwise when expanding
- 200ms duration for snappy feel

---

### 5. Expandable Detail Section

**Implementation:**
```dart
AnimatedSize(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  child: isExpanded
      ? Container(
          // ... detail content
          child: _buildDetailView(summary),
        )
      : const SizedBox.shrink(),
)
```

**Why AnimatedSize?**
- Automatically animates height changes
- Smooth transition (300ms)
- easeInOut curve for natural motion
- No manual height calculations needed

**Alternative Considered:**
- `AnimatedCrossFade` - Too complex for this use case
- Manual `AnimatedContainer` - Would need explicit height
- `ExpansionPanelList` - Too opinionated, less control

---

### 6. Column Alignment

**Layout Structure:**
```
Row (Table Row)
├── AnimatedRotation (40px)
├── SizedBox(50px) - Number
├── Expanded(flex:2) - Name
├── Expanded(flex:1) - User ID
├── Expanded(flex:1) - Department
├── Expanded(flex:1) - Masuk
├── Expanded(flex:1) - Telat
└── Expanded(flex:1) - Lembur
```

**Alignment Tips:**
- Use same flex values in header and data rows
- Keep fixed widths consistent (icon space, number)
- Use `MainAxisAlignment.center` for centered columns
- Add consistent `SizedBox(width: 8)` between columns

---

### 7. Performance Considerations

**Current Implementation:**
```dart
ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemBuilder: (context, index) {
    return _buildExpandableTableRow(summary, index);
  },
)
```

**Why this approach:**
- `shrinkWrap: true` - ListView size based on content
- `NeverScrollableScrollPhysics` - Parent handles scrolling
- Wrapped in `SingleChildScrollView` at screen level

**For large datasets (future optimization):**
- Remove `shrinkWrap` and use full height
- Enable ListView's own scrolling
- Consider pagination or virtual scrolling
- Current approach works fine for typical use (< 100 employees)

---

### 8. Customization Guide

#### Change Animations Speed
```dart
// In _buildExpandableTableRow:
AnimatedRotation(
  duration: const Duration(milliseconds: 150),  // Faster
  // ...
)

AnimatedSize(
  duration: const Duration(milliseconds: 500),  // Slower
  // ...
)
```

#### Change Alternating Colors
```dart
color: isEven ? Colors.white : Colors.blue[50]  // Bluish tint
```

#### Change Expand Icon
```dart
Icon(
  Icons.arrow_forward_ios,  // Different icon
  size: 16,                  // Smaller size
)
```

#### Add Column Sorting
```dart
// In header:
InkWell(
  onTap: () => _sortByColumn('name'),
  child: Row(
    children: [
      Text('Nama Karyawan'),
      Icon(_sortColumn == 'name' ? Icons.arrow_upward : Icons.arrow_downward),
    ],
  ),
)
```

---

### 9. Testing Checklist

#### Visual Testing
- [ ] Header aligned with data columns
- [ ] Alternating colors visible
- [ ] Hover effect working
- [ ] Icon rotates on click
- [ ] Detail section expands smoothly
- [ ] Detail section styling correct
- [ ] Badges display properly
- [ ] Icons in stats columns visible

#### Interaction Testing
- [ ] Click any row to expand
- [ ] Click again to collapse
- [ ] Multiple rows can be expanded
- [ ] Expand/collapse is smooth (no jank)
- [ ] Hover highlights row
- [ ] Detail content scrolls if needed

#### Responsive Testing
- [ ] Works on narrow screens
- [ ] Columns adjust proportionally
- [ ] Text doesn't overflow
- [ ] Badges don't break layout
- [ ] Detail section readable on mobile

---

### 10. Troubleshooting

#### Issue: Columns not aligned
**Solution:** Ensure header and data rows use same flex values and fixed widths

#### Issue: Animation stutters
**Solution:** Check if setState() is being called too frequently or if detail section is too complex

#### Issue: Expanded state lost on rebuild
**Solution:** Verify `_expandedRows` is not being cleared accidentally in setState

#### Issue: Hover doesn't work
**Solution:** Ensure InkWell is at the right level in widget tree and has proper size

#### Issue: Icon doesn't rotate
**Solution:** Check that `isExpanded` is correctly computed from `_expandedRows.contains(index)`

---

## Future Enhancements

### Possible Features to Add
1. **Column Sorting** - Click headers to sort
2. **Search/Filter** - Text field to filter rows
3. **Bulk Actions** - Checkboxes for multi-select
4. **Column Resizing** - Drag to resize columns
5. **Column Reordering** - Drag to reorder columns
6. **Export to CSV** - Download table data
7. **Sticky Header** - Keep header visible on scroll
8. **Row Selection** - Highlight selected row
9. **Keyboard Navigation** - Arrow keys to navigate
10. **Accessibility** - Screen reader support

### Code Maintainability
1. **Extract Constants** - Animation durations, colors
2. **Separate Widget File** - Move table to own file
3. **Add Tests** - Widget tests for interactions
4. **Internationalization** - Replace hardcoded strings
5. **Theme Integration** - Use app theme colors

---

## Migration Guide

If you need to revert to the old ExpansionTile design:

1. Restore `_buildEmployeeCard()` method from git history
2. Restore `_buildStat()` method from git history
3. Change `_buildSummaryTable()` to use ListView.builder with `_buildEmployeeCard`
4. Remove `_expandedRows` state variable
5. Remove `_buildExpandableTableRow()` method

Git command:
```bash
git show a87e983:lib/screens/attendance_screen.dart > lib/screens/attendance_screen.dart
```
(Replace `a87e983` with the commit hash before the changes)
