# Testing the Login Page

This guide provides instructions for testing the newly implemented login page.

## Quick Start

### Credentials
- **Username**: `admin`
- **Password**: `admin`

## Manual Testing Checklist

### 1. Initial Load
- [ ] Application opens to the login screen (not the main screen)
- [ ] "Login to Simporter" heading is visible
- [ ] Username and password fields are displayed
- [ ] LOGIN button is visible and enabled
- [ ] Right panel (blue gradient) is visible on desktop screens

### 2. Form Validation
- [ ] Click LOGIN without entering credentials → Error messages appear
- [ ] Enter only username → Password validation error appears
- [ ] Enter only password → Username validation error appears
- [ ] Error messages are clear and user-friendly

### 3. Password Toggle
- [ ] Password field shows dots/asterisks by default
- [ ] Click the eye icon → Password becomes visible
- [ ] Click the eye icon again → Password is hidden again
- [ ] Icon changes between eye and eye-off

### 4. Invalid Login
- [ ] Enter wrong username (e.g., "wronguser")
- [ ] Enter wrong password (e.g., "wrongpass")
- [ ] Click LOGIN
- [ ] Error message "Invalid username or password" appears
- [ ] User remains on login screen

### 5. Successful Login
- [ ] Enter username: `admin`
- [ ] Enter password: `admin`
- [ ] Click LOGIN
- [ ] Loading spinner briefly appears on button
- [ ] User is navigated to main application screen
- [ ] Cannot navigate back to login screen with back button

### 6. UI/UX Elements
- [ ] Form is centered and visually appealing
- [ ] Input fields have proper padding and spacing
- [ ] Button has hover effect (visual feedback)
- [ ] Focus states are visible when tabbing through fields
- [ ] Error messages are styled with appropriate colors

### 7. Responsive Design
- [ ] Desktop (>900px): Split screen with blue panel on right
- [ ] Tablet (600-900px): Single column, no blue panel
- [ ] Mobile (<600px): Single column, optimized spacing

### 8. Keyboard Navigation
- [ ] Tab key moves between fields in logical order
- [ ] Enter key in username field moves to password field
- [ ] Enter key in password field submits the form
- [ ] Escape key doesn't cause errors

### 9. Edge Cases
- [ ] Very long username doesn't break layout
- [ ] Very long password doesn't break layout
- [ ] Special characters in fields are handled correctly
- [ ] Copy/paste works in both fields

## Automated Testing

### Running Unit Tests

```bash
# Navigate to project directory
cd /home/runner/work/rekap_absensi_app/rekap_absensi_app

# Run all tests
flutter test

# Run only login screen tests
flutter test test/login_screen_test.dart

# Run tests with coverage
flutter test --coverage
```

### Test Coverage

The test suite includes:

1. **Widget Rendering Test**
   - Verifies all UI elements are present
   - Checks text content is correct

2. **Password Toggle Test**
   - Confirms visibility toggle functionality
   - Verifies icon changes correctly

3. **Form Validation Test**
   - Tests empty field validation
   - Ensures error messages appear

4. **Invalid Credentials Test**
   - Tests wrong username/password
   - Verifies error message display

5. **Successful Login Test**
   - Tests correct credentials
   - Verifies navigation to main screen

## Testing Different Scenarios

### Scenario 1: First Time User
**Steps:**
1. Launch the application
2. Observe the login screen
3. Try logging in without credentials
4. Read the validation errors
5. Enter correct credentials
6. Verify access to main application

**Expected Result:**
User understands they need to login and successfully authenticates.

### Scenario 2: Wrong Credentials
**Steps:**
1. Enter incorrect username
2. Enter incorrect password
3. Click LOGIN
4. Observe error message
5. Correct the credentials
6. Login successfully

**Expected Result:**
Clear error feedback, user can retry without confusion.

### Scenario 3: Mobile User
**Steps:**
1. Resize browser to mobile width (<600px)
2. Observe layout changes
3. Test all functionality on mobile viewport
4. Verify touch targets are large enough

**Expected Result:**
Login works perfectly on mobile devices.

## Performance Testing

### Metrics to Check
- [ ] Initial render time < 1 second
- [ ] Button click response < 100ms
- [ ] Form validation is instant
- [ ] Navigation transition is smooth
- [ ] No memory leaks (controllers disposed properly)

## Accessibility Testing

### Screen Reader
- [ ] Form fields are properly labeled
- [ ] Error messages are announced
- [ ] Button state changes are announced
- [ ] Navigation is announced

### Keyboard Only
- [ ] Can complete entire login flow without mouse
- [ ] Focus indicators are visible
- [ ] Tab order is logical
- [ ] No keyboard traps

### Visual
- [ ] Text has sufficient contrast
- [ ] Touch targets meet minimum size (48x48px)
- [ ] Error messages are distinguishable

## Browser/Platform Testing

### Desktop Browsers
- [ ] Chrome/Chromium
- [ ] Firefox
- [ ] Safari
- [ ] Edge

### Mobile Browsers
- [ ] Chrome Mobile (Android)
- [ ] Safari Mobile (iOS)

### Desktop Applications
- [ ] Windows desktop app
- [ ] macOS desktop app
- [ ] Linux desktop app

## Known Test Credentials

For testing purposes, the following credentials are hardcoded:

| Username | Password | Access Level |
|----------|----------|--------------|
| admin    | admin    | Full Access  |

## Debugging Tips

### Login Not Working
1. Check browser console for errors
2. Verify credentials are exactly "admin" / "admin" (case-sensitive)
3. Ensure route '/main' is properly configured
4. Check that MainScreen widget exists

### UI Issues
1. Clear browser cache and reload
2. Check screen width for responsive breakpoints
3. Verify all imports are correct
4. Check for CSS/styling conflicts

### Navigation Issues
1. Verify route is defined in main.dart
2. Check Navigator.pushReplacementNamed is used (not push)
3. Ensure context is valid when navigating
4. Check for any navigation guards or interceptors

## Test Results Template

Use this template to document your testing:

```
Test Date: [DATE]
Tester: [NAME]
Platform: [Windows/macOS/Linux/Web]
Browser: [Chrome/Firefox/Safari/Edge]
Screen Size: [Desktop/Tablet/Mobile]

PASSED TESTS:
- [ ] Initial load
- [ ] Form validation
- [ ] Password toggle
- [ ] Invalid login
- [ ] Successful login
- [ ] Responsive design
- [ ] Keyboard navigation

FAILED TESTS:
(List any failures here)

ISSUES FOUND:
(List any bugs or problems)

NOTES:
(Additional observations)
```

## CI/CD Integration

If you have continuous integration set up:

```yaml
# Example GitHub Actions workflow
name: Flutter Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
```

## Troubleshooting Common Issues

### Issue: "Cannot find route '/main'"
**Solution**: Ensure main.dart has the route defined:
```dart
routes: {
  '/main': (context) => const MainScreen(),
}
```

### Issue: "Widget tests fail with null context"
**Solution**: Wrap tests with MaterialApp:
```dart
await tester.pumpWidget(
  MaterialApp(home: LoginScreen()),
);
```

### Issue: "Password not hiding"
**Solution**: Check that TextFormField has `obscureText: _obscurePassword`

## Success Criteria

The login page implementation is considered successful when:

✅ All manual tests pass
✅ All automated tests pass
✅ Login with correct credentials navigates to main screen
✅ Login with incorrect credentials shows error message
✅ Design matches reference specifications
✅ Responsive design works on all screen sizes
✅ No console errors or warnings
✅ Code review passes
✅ Security scan passes

## Next Steps After Testing

Once testing is complete:
1. Document any issues found
2. Fix critical bugs
3. Optimize performance if needed
4. Get stakeholder approval
5. Deploy to production

## Support

If you encounter issues:
1. Check this testing guide
2. Review LOGIN_PAGE_IMPLEMENTATION.md
3. Check LOGIN_PAGE_VISUAL_DESIGN.md
4. Review the code in lib/screens/login_screen.dart
5. Run the automated tests for more details
