# Login Page Visual Design

This document describes the visual appearance of the implemented login page.

## Desktop/Large Screen View (≥900px width)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  ┌────────────────────────────┬──────────────────────────────────────────┐ │
│  │ LEFT PANEL (White)         │ RIGHT PANEL (Blue Gradient)              │ │
│  │                            │                                          │ │
│  │  👤 Simporter (blue)       │     ◯ (decorative circle, top-right)   │ │
│  │                            │                                          │ │
│  │                            │                                          │ │
│  │  Login to Simporter        │                                          │ │
│  │  ══════════════════        │     The AI-Driven Product                │ │
│  │                            │     Launch Toolbox                       │ │
│  │  Don't have an account?    │     ═══════════════════                 │ │
│  │  Create account (red)      │                                          │ │
│  │                            │     Leverage artificial intelligence     │ │
│  │  ┌──────────────────────┐  │     to streamline your product launch   │ │
│  │  │ Yourmail@box.com     │  │     process and maximize market impact. │ │
│  │  └──────────────────────┘  │                                          │ │
│  │                            │                                          │ │
│  │  ┌──────────────────────┐  │                                          │ │
│  │  │ Password          👁 │  │                                          │ │
│  │  └──────────────────────┘  │                                          │ │
│  │                            │                                          │ │
│  │  ┌──────────────────────┐  │                                          │ │
│  │  │      LOGIN           │  │                                          │ │
│  │  └──────────────────────┘  │                                          │ │
│  │     (blue button)          │                                          │ │
│  │                            │                                          │ │
│  │  Forgot your password?     │                                          │ │
│  │  (gray text)               │                                          │ │
│  │                            │                                          │ │
│  │                            │     Help | Any Questions?                │ │
│  │  Simporter Inc 2019        │     (white text, bottom)                 │ │
│  │  Privacy Policy •          │                                          │ │
│  │  Terms & Conditions        │                                          │ │
│  │  (small gray text)         │                                          │ │
│  └────────────────────────────┴──────────────────────────────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Mobile/Small Screen View (<900px width)

```
┌────────────────────────┐
│                        │
│  👤 Simporter (blue)   │
│                        │
│  Login to Simporter    │
│  ══════════════════    │
│                        │
│  Don't have an account?│
│  Create account (red)  │
│                        │
│  ┌──────────────────┐  │
│  │ Yourmail@box.com │  │
│  └──────────────────┘  │
│                        │
│  ┌──────────────────┐  │
│  │ Password      👁 │  │
│  └──────────────────┘  │
│                        │
│  ┌──────────────────┐  │
│  │     LOGIN        │  │
│  └──────────────────┘  │
│                        │
│  Forgot your password? │
│                        │
│                        │
│  Simporter Inc 2019    │
│  Privacy Policy •      │
│  Terms & Conditions    │
│                        │
└────────────────────────┘
```

## Color Palette

### Primary Colors
- **Blue Primary**: #5B8DEF (Buttons, Logo, Links)
- **Blue Gradient End**: #4A7BCE (Background gradient)
- **White**: #FFFFFF (Form panel background)

### Text Colors
- **Heading Dark**: #1F2937 (Main headings)
- **Body Gray**: #6B7280 (Secondary text)
- **Light Gray**: #9CA3AF (Tertiary text, footer)

### Accent Colors
- **Red Link**: #F87171 (Create account link)
- **Success Green**: Not used in login
- **Error Red**: #DC2626 (Error messages)

### UI Elements
- **Input Background**: #F9FAFB (Light gray)
- **Border Color**: #E5E7EB (Input borders)
- **Focus Border**: #5B8DEF (Active input)

## Typography

### Font Weights
- **Bold (700)**: Headings, Button text
- **Semi-bold (600)**: Logo
- **Medium (500)**: Links
- **Regular (400)**: Body text

### Font Sizes
- **Logo**: 24px
- **Main Heading**: 28px
- **Marketing Heading**: 48px
- **Body Text**: 14px
- **Button Text**: 16px
- **Footer Text**: 12px

## Component Details

### Input Fields
- **Height**: 50px
- **Border Radius**: 8px
- **Padding**: 16px horizontal
- **Border**: 1px solid #E5E7EB
- **Focus State**: 2px solid #5B8DEF
- **Background**: #F9FAFB

### Login Button
- **Height**: 50px
- **Width**: 100% (full width)
- **Border Radius**: 8px
- **Background**: #5B8DEF
- **Text Color**: White
- **Text**: "LOGIN" (uppercase, bold, letter-spacing: 1)
- **Hover State**: Slightly darker blue
- **Loading State**: Shows circular progress indicator

### Password Toggle Icon
- **Position**: Right side of password input
- **Icon**: Eye (visible) / Eye-off (hidden)
- **Color**: #6B7280
- **Size**: 24px

### Error Message Box
- **Background**: #FEE2E2 (Light red)
- **Border**: 1px solid #FECACA
- **Border Radius**: 8px
- **Padding**: 8px 12px
- **Icon**: Error outline icon
- **Text Color**: #DC2626

## Layout Specifications

### Desktop Layout
- **Split Ratio**: 40% (Left) / 60% (Right)
- **Left Panel Padding**: 64px horizontal, 32px vertical
- **Right Panel Padding**: 80px
- **Breakpoint**: 900px width

### Mobile Layout
- **Padding**: 24px horizontal, 32px vertical
- **Right Panel**: Hidden
- **Scrollable**: Yes

### Spacing
- **Logo to Heading**: 60px
- **Heading to Form**: 40px
- **Between Inputs**: 20px
- **Input to Button**: 24px
- **Button to Link**: 16px
- **Link to Footer**: 60px

## Right Panel Design

### Background
- **Gradient**: Linear from #5B8DEF (top-left) to #4A7BCE (bottom-right)
- **Decorative Element**: 300x300px circle, 10% white opacity, positioned top-right (-100px, -100px)

### Content Layout
- **Heading**: Bold, 48px, white, line-height: 1.2
- **Description**: 18px, 90% white opacity, line-height: 1.6
- **Help Links**: Bottom-aligned, underlined, 14px

## Interactive States

### Input Fields
1. **Default**: Light gray background, gray border
2. **Focus**: Blue border (2px), maintains background
3. **Filled**: Same as default but with text
4. **Error**: Red border, error message below

### Button States
1. **Default**: Blue background, white text
2. **Hover**: Slightly darker blue (visual feedback)
3. **Loading**: Disabled, shows spinner
4. **Disabled**: Gray background

### Password Toggle
1. **Hidden**: Eye-off icon, password obscured
2. **Visible**: Eye icon, password visible
3. **Hover**: Slight opacity change

## Responsive Behavior

### Large Screens (≥900px)
- Split screen layout visible
- Both panels shown
- Maximum content readability

### Medium Screens (600-899px)
- Single column layout
- Right panel hidden
- Left panel takes full width

### Small Screens (<600px)
- Single column layout
- Reduced padding (24px)
- Optimized for mobile viewing
- Touch-friendly input sizes maintained

## Accessibility Features
- **ARIA Labels**: Proper form labeling
- **Keyboard Navigation**: Tab order maintained
- **Focus Indicators**: Clear focus states
- **Error Announcements**: Screen reader friendly
- **Touch Targets**: Minimum 48x48px (buttons, icons)
- **Contrast Ratios**: WCAG AA compliant

## Animation & Transitions
- **Loading Spinner**: Smooth rotation
- **Error Messages**: Fade in/slide down
- **Button Press**: Subtle scale effect
- **Input Focus**: Smooth border transition
- **Navigation**: Replace transition (no animation for better UX)

## Professional Polish
- **Consistent Spacing**: All elements use 4px/8px grid
- **Visual Hierarchy**: Clear primary/secondary/tertiary levels
- **Brand Cohesion**: Consistent use of brand colors
- **Modern Aesthetic**: Clean, minimal, professional
- **User-Friendly**: Clear calls-to-action, helpful error messages
