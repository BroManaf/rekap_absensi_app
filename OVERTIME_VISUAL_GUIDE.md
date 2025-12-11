# Overtime Calculation - Visual Guide

## Time Periods

```
00:00                07:00      12:00      16:00   17:01         24:00
  |                    |          |          |       |             |
  |    Pre-Work        |  Morning |Afternoon | Gap  |  Overtime   |
  |    Not Counted     |  Shift   |  Shift   |  NC  |   Period    |
  |                    |          |          |       |             |
```

**NC** = Not Counted

## Shift Definitions

| Period | Start | End | Counted? |
|--------|-------|-----|----------|
| Morning Shift | 07:00 | 12:00 | ✅ Yes |
| Afternoon Shift | 12:01 | 16:00 | ✅ Yes |
| Gap Period | 16:01 | 17:00 | ❌ No |
| Overtime | 17:01 | 05:00 | ✅ Yes (calculated from 17:00) |

## Examples

### Example 1: No Overtime (Checkout before gap)
```
Clock In: 08:00    Clock Out: 15:00
08:00 ──────────────────────> 15:00
        7 hours work
```
**Result:** 7 hours (420 minutes)

### Example 2: Checkout in Gap Period
```
Clock In: 08:00    Clock Out: 16:30
08:00 ──────────────────────> 16:00 | 16:30
        8 hours work            gap (not counted)
```
**Result:** 8 hours (480 minutes)
- Regular work: 08:00-16:00 = 8 hours
- Gap time: 16:00-16:30 = NOT COUNTED

### Example 3: With Overtime (Problem Statement Example)
```
Clock In: 08:00                                    Clock Out: 20:00
08:00 ──────────────────────> 16:00 | gap | 17:00 ──────────> 20:00
        8 hours work           (NC)      3 hours overtime
```
**Result:** 11 hours (660 minutes)
- Regular work: 08:00-16:00 = 8 hours (480 min)
- Gap time: 16:00-17:00 = NOT COUNTED
- Overtime: 17:00-20:00 = 3 hours (180 min)
- **Total: 8 + 3 = 11 hours**

### Example 4: Minimum Overtime
```
Clock In: 07:00                                    Clock Out: 17:01
07:00 ──────────────────────> 16:00 | gap | 17:00─> 17:01
        9 hours work           (NC)      1 min OT
```
**Result:** 9 hours 1 minute (541 minutes)
- Regular work: 07:00-16:00 = 9 hours (540 min)
- Gap time: 16:00-17:00 = NOT COUNTED
- Overtime: 17:00-17:01 = 1 minute
- **Total: 540 + 1 = 541 minutes**

### Example 5: Exactly at Overtime Threshold
```
Clock In: 07:00                                    Clock Out: 17:00
07:00 ──────────────────────> 16:00 | 16:00 ──> 17:00
        9 hours work               gap (not counted)
```
**Result:** 9 hours (540 minutes)
- Regular work: 07:00-16:00 = 9 hours
- Gap time: 16:00-17:00 = NOT COUNTED
- Overtime: None (17:00 is before 17:01 threshold)
- **Total: 540 minutes**

## Key Rules

1. **Regular Hours:** Counted from check-in (or department start time, whichever is later) to 16:00
2. **Gap Period:** 16:00 to 17:00 is NEVER counted as work time
3. **Overtime Trigger:** Only if checkout is at or after 17:01
4. **Overtime Calculation:** When triggered, calculated from 17:00 (not 17:01)
5. **Lateness:** Calculated based on department start time vs. actual check-in

## Excel Column Mapping

### OLD Mapping (Before Changes)
| Column | Field | Purpose |
|--------|-------|---------|
| C, D | Jam Masuk Pagi | Morning check-in |
| E | Jam Keluar Pagi | Morning check-out |
| F, G | Jam Masuk Siang | Afternoon check-in |
| H | Jam Keluar Siang | Afternoon check-out (18:00) |
| I, J | Jam Masuk Lembur | **Overtime check-in** |
| K | Jam Keluar Lembur | **Overtime check-out** |

### NEW Mapping (After Changes)
| Column | Field | Purpose |
|--------|-------|---------|
| C, D | Jam Masuk Pagi | Morning check-in |
| E | Jam Keluar Pagi | Morning check-out |
| F, G | Jam Masuk Siang | Afternoon check-in |
| H | Jam Keluar Siang | Afternoon check-out (16:00) |
| I, J | **Jam Masuk Lembur** | **FINAL CLOCK-OUT TIME** ⭐ |
| K | Jam Keluar Lembur | ❌ No longer used |

⭐ **Major Change:** Column I/J now represents the final clock-out time, not overtime check-in!

## Code Logic Flow

```
INPUT: checkInTime, checkOutTime, departmentStartTime

STEP 1: Calculate effective start
effectiveStart = max(checkInTime, departmentStartTime)

STEP 2: Determine which case applies
IF checkOutTime <= 16:00:
    return (checkOutTime - effectiveStart)
    
ELSE IF 16:00 < checkOutTime < 17:01:
    return (16:00 - effectiveStart)  // Gap not counted
    
ELSE IF checkOutTime >= 17:01:
    regularHours = (16:00 - effectiveStart)
    overtimeHours = (checkOutTime - 17:00)  // Note: from 17:00, not 17:01
    return (regularHours + overtimeHours)
```

## Lateness Calculation

Lateness is independent of checkout time and only depends on check-in:

```
IF checkInTime > departmentStartTime:
    lateness = checkInTime - departmentStartTime
ELSE:
    lateness = 0
```

**Example:**
- Department start: 07:00
- Check in: 08:00
- Lateness: 08:00 - 07:00 = 60 minutes (1 hour)
