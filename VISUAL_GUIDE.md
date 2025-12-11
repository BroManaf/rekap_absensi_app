# Visual Guide - UI/UX Redesign
## Dark Theme Implementation Visual Reference

This guide provides a visual description of the redesigned interface components.

---

## 🎨 Color Reference Card

### Main Background
```
Primary Background: #0F1419 (Very dark blue-gray)
┌─────────────────────────────────────┐
│                                     │
│     Main application background     │
│                                     │
└─────────────────────────────────────┘
```

### Sidebar
```
Secondary Background: #1A1F2E (Dark blue-gray)
┌─────┐
│     │  Logo with gradient
│ ≡   │  Purple (#667EEA) to Purple (#764BA2)
│     │
│ ■   │  Active item with gradient glow
│ □   │  Inactive items with hover effect
│ □   │
│     │
│ ⚙   │  Settings at bottom
└─────┘
```

---

## 📱 Screen Layouts

### Main Layout
```
┌─────────────────────────────────────────────────────────┐
│ ┌────┐  ┌──────────────────────────────────────────┐  │
│ │    │  │                                          │  │
│ │ ≡  │  │  Screen Content Area                     │  │
│ │    │  │  (Gradient background #0F1419->#1A1F2E) │  │
│ │ ■  │  │                                          │  │
│ │ □  │  │                                          │  │
│ │    │  │                                          │  │
│ │ ⚙  │  │                                          │  │
│ └────┘  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
Sidebar (80px) + Content Area (Expanded)
```

---

## 🖼️ Component Visualizations

### 1. Sidebar Components

#### Logo (Top)
```
┌────────────┐
│  ┌──────┐  │
│  │      │  │  48x48 container
│  │  ☑   │  │  Gradient background
│  │      │  │  Purple-blue gradient
│  └──────┘  │  Box shadow with glow
└────────────┘
```

#### Menu Item (Active)
```
┌──────────┐
│          │
│    ■     │  Gradient background (#667EEA->#764BA2)
│          │  Icon: white, 24px
└──────────┘  Glowing shadow
```

#### Menu Item (Hover)
```
┌──────────┐
│          │
│    □     │  Hover background (#2A3441)
│          │  Icon: white, 24px
└──────────┘  Smooth transition (200ms)
```

#### Menu Item (Inactive)
```
┌──────────┐
│          │
│    □     │  Transparent background
│          │  Icon: gray (#9CA3AF), 24px
└──────────┘  No shadow
```

---

### 2. Upload Area (Empty State)

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│                    ┌─────────────┐                      │
│                    │             │                      │
│                    │   ☁️ ⬆️     │  80x80 icon          │
│                    │             │  Gradient or plain   │
│                    └─────────────┘                      │
│                                                         │
│            Drop your files here or browse               │
│                                                         │
│          ┌────────────────────────────┐                │
│          │ Supported formats: .xlsx   │                │
│          └────────────────────────────┘                │
│                                                         │
└─────────────────────────────────────────────────────────┘
Border: Solid when idle, Glowing when dragging
Background: Card color (#242B3D)
Border Radius: 24px
Padding: 64px
```

---

### 3. Header Section

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  Rekap Absensi Karyawan    <- Gradient text effect     │
│  (White #F9FAFB -> Blue #5B8DEF)                       │
│                                                         │
│  Upload file Excel absensi untuk melihat...            │
│  (Gray #9CA3AF, 14px)                                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

### 4. Employee Card (Collapsed)

```
┌─────────────────────────────────────────────────────────┐
│ ┌───┐  John Doe                                  v     │
│ │ 1 │  ID: EMP001    Dept: IT                          │
│ └───┘                                                   │
│      ┌──────┐  ┌──────┐  ┌──────┐                     │
│      │🔓 20  │  │⏰ 2h  │  │🌙 5h │                     │
│      │Masuk │  │Telat │  │Lembur│                     │
│      └──────┘  └──────┘  └──────┘                     │
└─────────────────────────────────────────────────────────┘

Number Badge:
- 44x44 container
- Gradient (#667EEA->#764BA2)
- White text, bold, 16px
- Border radius: 12px
- Shadow with glow

ID/Department Badges:
- Rounded containers (6px radius)
- Semi-transparent background
- Border with color
- Small text (11px)

Stats:
- Color-coded backgrounds
- Icon + value + label
- Green (Masuk), Orange (Telat), Blue (Lembur)
```

---

### 5. Employee Card (Expanded - Detail View)

```
┌─────────────────────────────────────────────────────────┐
│ ┌───┐  John Doe                                  ^     │
│ │ 1 │  ID: EMP001    Dept: IT                          │
│ └───┘                                                   │
│      ┌──────┐  ┌──────┐  ┌──────┐                     │
│      │🔓 20  │  │⏰ 2h  │  │🌙 5h │                     │
│      │Masuk │  │Telat │  │Lembur│                     │
│      └──────┘  └──────┘  └──────┘                     │
│                                                         │
│  ╔═══════════════════════════════════════════════════╗ │
│  ║ ⏰ Rincian Keterlambatan                         ║ │
│  ║ ┌─────────────────────────────────────────────┐ ║ │
│  ║ │ Tanggal 5 (Sen)  Masuk 09:30    Telat: 30m │ ║ │
│  ║ └─────────────────────────────────────────────┘ ║ │
│  ║                                                   ║ │
│  ║ 🌙 Rincian Lembur                                ║ │
│  ║ ┌─────────────────────────────────────────────┐ ║ │
│  ║ │ Tanggal 10 (Jum)  Pulang 20:00  Lembur: 3h │ ║ │
│  ║ └─────────────────────────────────────────────┘ ║ │
│  ║                                                   ║ │
│  ║ 🏥 Rincian Izin/Sakit                           ║ │
│  ║ ✓ Tidak ada izin/sakit                          ║ │
│  ╚═══════════════════════════════════════════════════╝ │
└─────────────────────────────────────────────────────────┘

Detail Container:
- Dark background (#0F1419 with 50% opacity)
- Border radius: 12px
- Border: Semi-transparent (#374151)
- Padding: 20px

Detail Rows:
- Color-coded backgrounds (10% opacity)
- Color-coded borders (30% opacity)
- Border radius: 10px
- Padding: 14px
```

---

### 6. Summary Header

```
┌─────────────────────────────────────────────────────────┐
│  Rekap Absensi                                          │
│  📄 filename.xlsx                                       │
│                                                         │
│                        ┌────────────┐  ┌─────────────┐ │
│                        │👥 25 karya.│  │ 🔄 Upload  │ │
│                        └────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────┘

Badge:
- Surface background (#1E2530)
- Border radius: 8px
- Icon + text
- Padding: 12px x 6px

Button:
- Primary accent background (#5B8DEF)
- White text
- Border radius: 12px
- Icon + label
- No shadow (elevation: 0)
```

---

### 7. Loading State

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│                       ⟳                                 │
│                   (Spinning)                            │
│                  48x48, Blue                            │
│                                                         │
│              Memproses file Excel...                    │
│                                                         │
└─────────────────────────────────────────────────────────┘

Progress Indicator:
- Size: 48x48
- Stroke width: 3px
- Color: Primary accent (#5B8DEF)
- Smooth rotation animation
```

---

### 8. Historical Screen (Empty State)

```
┌─────────────────────────────────────────────────────────┐
│  Historis Absensi  <- Gradient text                    │
│  Lihat riwayat data absensi karyawan                   │
│                                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │                                                   │ │
│  │                  ┌─────────────┐                 │ │
│  │                  │             │                 │ │
│  │                  │   🕐        │  120x120        │ │
│  │                  │   (Icon)    │  Gradient       │ │
│  │                  │             │  + Shadow       │ │
│  │                  └─────────────┘                 │ │
│  │                                                   │ │
│  │              Historis Absensi                     │ │
│  │                                                   │ │
│  │    Fitur ini akan menampilkan riwayat lengkap    │ │
│  │         data absensi karyawan dengan...          │ │
│  │                                                   │ │
│  │               ┌──────────────┐                   │ │
│  │               │ ℹ️ Coming Soon│                   │ │
│  │               └──────────────┘                   │ │
│  │                                                   │ │
│  └───────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘

Icon Container:
- 120x120 size
- Gradient background (#667EEA->#764BA2)
- Border radius: 30px
- Glowing shadow (blue)
- White icon, 60px

Coming Soon Badge:
- Surface background
- Border with color
- Icon + text
- Small size
```

---

## 🎨 Status Color Usage

### Success (Green #10B981)
```
┌──────────────┐
│ 🔓 20 Masuk  │  Attendance count
└──────────────┘  Background: 12% opacity
```

### Warning (Orange #F59E0B)
```
┌──────────────┐
│ ⏰ 2h Telat   │  Late time
└──────────────┘  Background: 12% opacity
```

### Info (Blue #3B82F6)
```
┌──────────────┐
│ 🌙 5h Lembur │  Overtime
└──────────────┘  Background: 12% opacity
```

### Error (Red #EF4444)
```
┌────────────────────────┐
│ 🏥 Rincian Izin/Sakit  │  Absence section
└────────────────────────┘  Background: 10% opacity
```

---

## 🔤 Typography Scale

```
Display Large:    32px, Bold     (Main headings)
Display Medium:   28px, Bold     (Section headings)
Display Small:    24px, SemiBold (Subsection headings)
Headline Medium:  20px, SemiBold (Card titles)
Title Large:      18px, SemiBold (Content titles)
Title Medium:     16px, Medium   (Labels)
Title Small:      14px, Medium   (Small labels)
Body Large:       16px, Regular  (Body text)
Body Medium:      14px, Regular  (Secondary text)
Body Small:       12px, Regular  (Captions, hints)
```

---

## 📏 Spacing Scale

```
Micro:   4px   (Icon-text gap)
Small:   8px   (Between related elements)
Medium:  12px  (Between components)
Regular: 16px  (Standard spacing)
Large:   20px  (Section spacing)
XL:      24px  (Card padding)
XXL:     32px  (Screen padding)
XXXL:    48px  (Major sections)
Huge:    64px  (Upload area padding)
```

---

## 🎭 Shadow Specifications

### Subtle Card Shadow
```
color: black @ 10% opacity
blur: 8px
offset: (0, 2px)
```

### Card Shadow
```
color: black @ 20% opacity
blur: 12px
offset: (0, 4px)
```

### Glow Shadow (Active/Hover)
```
color: primary accent @ 30-40% opacity
blur: 12-20px
offset: (0, 4-8px)
```

---

## 🔄 Animation Specifications

### Standard Transition
```
duration: 200ms
curve: easeInOut
properties: color, background, transform
```

### Hover Effect
```
- Color change: 200ms
- Background change: 200ms
- Scale: 1.0 (no scale change)
- Cursor: pointer
```

### Active State
```
- Gradient application: instant
- Shadow addition: 200ms fade-in
- Icon color: instant
```

---

## 💡 Interaction States

### Button States
```
Normal:   Accent color background, white text
Hover:    Slightly lighter background
Active:   Slightly darker background
Disabled: Gray background, gray text
```

### Input States
```
Normal:   Surface background, border color
Focus:    Primary accent border (2px)
Error:    Error color border
Disabled: Darker background, gray text
```

### Card States
```
Normal:   Standard shadow
Hover:    Enhanced shadow (cards with interaction)
Active:   Pressed appearance (slight transform)
```

---

## 🎯 Accessibility Notes

### Color Contrast Ratios
- Primary text on dark background: >7:1 (AAA)
- Secondary text on dark background: >4.5:1 (AA)
- Accent colors on dark background: >4.5:1 (AA)

### Interactive Element Sizes
- Minimum touch target: 44x44px
- Icon buttons: 48x48px
- Text buttons: minimum height 40px

### Focus Indicators
- 2px border in primary accent color
- Clear visual distinction from normal state
- Maintained for keyboard navigation

---

## 📐 Layout Grid

```
┌─────────────────────────────────────────────┐
│ [Sidebar 80px] │ [Content Area]            │
│                │                            │
│                │  Padding: 32px             │
│                │                            │
│                │  Content width: flexible   │
│                │  Max content width: none   │
│                │                            │
└─────────────────────────────────────────────┘
```

---

## ✨ Special Effects

### Gradient Text
```
Shader Mask with Linear Gradient
Colors: White (#F9FAFB) -> Blue (#5B8DEF)
Applied to: Page titles
```

### Glassmorphism
```
Background: white @ 10% opacity
Border: white @ 20% opacity, 1px
Shadow: black @ 10% opacity, blur 20px
Backdrop: blur (where supported)
```

### Gradient Backgrounds
```
Direction: top-left to bottom-right
Colors: #667EEA (start) -> #764BA2 (end)
Applied to: Logo, active items, badges
```

---

This visual guide complements the technical documentation and provides designers and developers with a clear understanding of the implemented design system.
