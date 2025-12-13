# Login Page Visual Guide

## Desktop Layout (Width >= 800px)

```
┌────────────────────────────────────────────────────────────────────────────┐
│                                                                            │
│  ┌─────────────────────────────┬──────────────────────────────────────┐  │
│  │                             │                                      │  │
│  │         WHITE SECTION       │         DARK SECTION                 │  │
│  │         (Form Area)         │         (Info Area)                  │  │
│  │                             │                                      │  │
│  │  ┌──────────────┐          │  ╔════════════════════════════════╗ │  │
│  │  │              │          │  ║ 🛠️  Visit our Support Center  ║ │  │
│  │  │   🔒 LOGO    │          │  ║     Get guidance from our      ║ │  │
│  │  │              │          │  ║     Support team.          →   ║ │  │
│  │  └──────────────┘          │  ╚════════════════════════════════╝ │  │
│  │                             │                                      │  │
│  │    Welcome back             │  ╔════════════════════════════════╗ │  │
│  │    Please enter your        │  ║ 🗺️  View our Product Roadmap  ║ │  │
│  │    details.                 │  ║     Browse and vote on         ║ │  │
│  │                             │  ║     what's next.           →   ║ │  │
│  │  Email                      │  ╚════════════════════════════════╝ │  │
│  │  ┌─────────────────────┐   │                                      │  │
│  │  │ Enter your email    │   │  ╔════════════════════════════════╗ │  │
│  │  └─────────────────────┘   │  ║ 🚀 Check out latest releases  ║ │  │
│  │                             │  ║     See new features and       ║ │  │
│  │  Password                   │  ║     updates.               →   ║ │  │
│  │  ┌─────────────────────┐   │  ╚════════════════════════════════╝ │  │
│  │  │ •••••••••••    👁️  │   │                                      │  │
│  │  └─────────────────────┘   │  ╔════════════════════════════════╗ │  │
│  │                             │  ║ 👥 Join our Slack Community   ║ │  │
│  │  ☐ Remember me              │  ║     Connect with thousands     ║ │  │
│  │            Forgot Password  │  ║     of Cerulean users.     →   ║ │  │
│  │                             │  ╚════════════════════════════════╝ │  │
│  │  ┌─────────────────────┐   │                                      │  │
│  │  │      Submit         │   │    Gradient Background:              │  │
│  │  └─────────────────────┘   │    #374151 → #1F2937 → #111827      │  │
│  │                             │                                      │  │
│  │  Don't have an account?     │                                      │  │
│  │  Request a free trial       │                                      │  │
│  │                             │                                      │  │
│  │     presented by            │                                      │  │
│  │      ┌─────────┐           │                                      │  │
│  │      │ COMPANY │           │                                      │  │
│  │      └─────────┘           │                                      │  │
│  │                             │                                      │  │
│  └─────────────────────────────┴──────────────────────────────────────┘  │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

## Mobile Layout (Width < 800px)

```
┌────────────────────────────┐
│                            │
│    ┌──────────────┐       │
│    │              │       │
│    │   🔒 LOGO    │       │
│    │              │       │
│    └──────────────┘       │
│                            │
│      Welcome back          │
│      Please enter your     │
│      details.              │
│                            │
│    Email                   │
│    ┌──────────────────┐   │
│    │ Enter your email │   │
│    └──────────────────┘   │
│                            │
│    Password                │
│    ┌──────────────────┐   │
│    │ •••••••••   👁️  │   │
│    └──────────────────┘   │
│                            │
│    ☐ Remember me           │
│          Forgot Password   │
│                            │
│    ┌──────────────────┐   │
│    │     Submit       │   │
│    └──────────────────┘   │
│                            │
│    Don't have an account?  │
│    Request a free trial    │
│                            │
│       presented by         │
│        ┌─────────┐        │
│        │ COMPANY │        │
│        └─────────┘        │
│                            │
└────────────────────────────┘
```

## Color Palette

### Primary Colors
- **White Section Background**: `#FFFFFF`
- **Dark Section Gradient**: 
  - Top: `#374151` (Dark Gray)
  - Middle: `#1F2937` (Darker Gray)
  - Bottom: `#111827` (Nearly Black)

### Text Colors
- **Primary Text**: `#1A1A1A` (Almost Black)
- **Secondary Text**: `#6B7280` (Gray)
- **Placeholder Text**: `#D1D5DB` (Light Gray)

### UI Elements
- **Button Background**: `#000000` (Black)
- **Button Text**: `#FFFFFF` (White)
- **Border Color**: `#D1D5DB` (Light Gray)
- **Focus Border**: `#000000` (Black)
- **Error Background**: `#EF4444` (Red)

### Info Cards (Dark Section)
- **Card Background**: `rgba(255, 255, 255, 0.05)`
- **Card Border**: `rgba(255, 255, 255, 0.1)`
- **Icon Background**: `rgba(255, 255, 255, 0.1)`
- **Text**: `#FFFFFF` (White)
- **Subtitle**: `rgba(255, 255, 255, 0.7)`
- **Arrow**: `rgba(255, 255, 255, 0.5)`

## Typography

### Font Sizes
- **Title (Welcome back)**: 30px, Bold
- **Subtitle**: 16px, Regular
- **Labels**: 14px, Medium (500)
- **Input Text**: 16px, Regular
- **Button Text**: 16px, Medium (500)
- **Links**: 14px, Medium (500)
- **Footer Text**: 12px, Regular

### Font Family
- Default: System font (Flutter default)
- Can be customized using app's theme (currently set to 'Inter')

## Spacing & Dimensions

### Padding
- **Desktop Content**: 48px
- **Mobile Content**: 24px
- **Card Padding**: 20-24px
- **Input Padding**: 16px horizontal, 12px vertical

### Element Heights
- **Input Fields**: 48px (with padding)
- **Button**: 48px
- **Checkbox**: 20px
- **Logo Icon**: 48x48px
- **Info Card Icons**: 48x48px

### Spacing Between Elements
- **Logo to Title**: 32px
- **Title to Subtitle**: 8px
- **Subtitle to First Input**: 32px
- **Between Inputs**: 20px
- **Input to Checkbox**: 16px
- **Checkbox to Button**: 24px
- **Button to Signup Text**: 24px
- **Signup to Footer**: 32px
- **Between Info Cards**: 24px

### Border Radius
- **Input Fields**: 8px
- **Buttons**: 8px
- **Info Cards**: 12px
- **Logo Container**: 8px
- **Company Badge**: 4px

## Interactive States

### Buttons
- **Normal**: Black background, white text
- **Hover**: Slight opacity change (0.9)
- **Pressed**: Scale down slightly
- **Disabled**: Gray background, gray text
- **Loading**: Shows circular progress indicator

### Input Fields
- **Normal**: Light gray border
- **Focus**: Black border (2px width)
- **Error**: Red border, error text below
- **Filled**: Maintains focus border style

### Links
- **Normal**: Medium font weight
- **Hover**: Underline or color change
- **Active**: Darker color

### Checkbox
- **Unchecked**: Empty white box with border
- **Checked**: Black background with checkmark
- **Hover**: Slight scale or shadow

### Password Toggle
- **Hidden**: Eye icon (visibility)
- **Visible**: Eye-off icon (visibility_off)
- **Hover**: Opacity or color change

## Validation States

### Empty Field Error
```
┌─────────────────────┐
│ Enter your email    │ ← Red border
└─────────────────────┘
❌ Email is required    ← Error message (red text, 12px)
```

### Invalid Credentials Error
```
┌────────────────────────────────────┐
│ ❌ Invalid email or password.     │
│    Please try again.               │
└────────────────────────────────────┘
SnackBar appears at bottom (red background)
```

## Loading State

### During Login
```
┌─────────────────────┐
│    ⟳  Loading...    │ ← Button shows spinner
└─────────────────────┘
Button is disabled during this state
```

## Flow Diagram

```
App Start
    ↓
AuthChecker
    ↓
Check SharedPreferences
    ├─→ isLoggedIn = true → Navigate to /home (MainScreen)
    └─→ isLoggedIn = false → Navigate to /login (LoginPage)
            ↓
        User Login
            ↓
        Validate Form
            ├─→ Invalid → Show Error
            └─→ Valid
                    ↓
                Check Credentials
                    ├─→ Wrong → Show SnackBar Error
                    └─→ Correct (admin/admin)
                            ↓
                        Save Login Status
                            ↓
                        Navigate to /home
```

## Logout Flow

```
Settings Screen
    ↓
Click "Keluar" Button
    ↓
Confirmation Dialog
    ├─→ Cancel → Stay in Settings
    └─→ Confirm
            ↓
        Clear SharedPreferences (isLoggedIn = false)
            ↓
        Navigate to /login (Remove all routes)
```

## Accessibility Features

1. **Keyboard Navigation**: All interactive elements are keyboard accessible
2. **Screen Reader Support**: Proper semantic labels on all elements
3. **Focus Indicators**: Clear focus states on all interactive elements
4. **Error Messages**: Clear and descriptive validation errors
5. **Contrast**: High contrast text for readability
6. **Touch Targets**: All buttons and interactive elements are minimum 48x48px

## Responsive Breakpoints

- **Mobile**: width < 800px
- **Desktop**: width >= 800px

The layout automatically adjusts based on screen width:
- Below 800px: Single column (form only)
- At or above 800px: Split layout (form + info)
