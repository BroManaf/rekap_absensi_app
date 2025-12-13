import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rekap_absensi_app/screens/login_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Initialize shared preferences with mock values
    SharedPreferences.setMockInitialValues({});
  });

  group('LoginPage Widget Tests', () {
    testWidgets('Login page displays all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Check for welcome text
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Please enter your details.'), findsOneWidget);

      // Check for email field
      expect(find.text('Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Enter your email'), findsOneWidget);

      // Check for password field
      expect(find.text('Password'), findsOneWidget);

      // Check for remember me checkbox
      expect(find.text('Remember me'), findsOneWidget);

      // Check for forgot password link
      expect(find.text('Forgot Password'), findsOneWidget);

      // Check for submit button
      expect(find.text('Submit'), findsOneWidget);

      // Check for sign up text
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Request a free trial'), findsOneWidget);
    });

    testWidgets('Email validation shows error for empty field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Find and tap the submit button
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      await tester.tap(submitButton);
      await tester.pump();

      // Check for validation error
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('Password validation shows error for empty field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Enter email but leave password empty
      final emailField = find.widgetWithText(TextFormField, 'Enter your email');
      await tester.enterText(emailField, 'admin');

      // Find and tap the submit button
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      await tester.tap(submitButton);
      await tester.pump();

      // Check for validation error
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Find password field
      final passwordField = find.byType(TextFormField).at(1);
      
      // Initially, password should be obscured
      TextFormField passwordWidget = tester.widget(passwordField);
      expect(passwordWidget.obscureText, true);

      // Find and tap the visibility toggle icon
      final visibilityToggle = find.byIcon(Icons.visibility);
      await tester.tap(visibilityToggle);
      await tester.pump();

      // Password should now be visible
      passwordWidget = tester.widget(passwordField);
      expect(passwordWidget.obscureText, false);

      // Tap again to hide
      final visibilityOffToggle = find.byIcon(Icons.visibility_off);
      await tester.tap(visibilityOffToggle);
      await tester.pump();

      // Password should be obscured again
      passwordWidget = tester.widget(passwordField);
      expect(passwordWidget.obscureText, true);
    });

    testWidgets('Remember me checkbox can be toggled', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Find checkbox
      final checkbox = find.byType(Checkbox);
      
      // Initially unchecked
      Checkbox checkboxWidget = tester.widget(checkbox);
      expect(checkboxWidget.value, false);

      // Tap to check
      await tester.tap(checkbox);
      await tester.pump();

      // Now checked
      checkboxWidget = tester.widget(checkbox);
      expect(checkboxWidget.value, true);
    });

    testWidgets('Login with invalid credentials shows error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
          routes: {
            '/home': (context) => const Scaffold(body: Text('Home Page')),
          },
        ),
      );

      // Enter invalid credentials
      final emailField = find.widgetWithText(TextFormField, 'Enter your email');
      await tester.enterText(emailField, 'wrong@email.com');

      final passwordField = find.widgetWithText(TextFormField, 'Enter your password');
      await tester.enterText(passwordField, 'wrongpassword');

      // Tap submit
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      await tester.tap(submitButton);
      await tester.pump();
      
      // Wait for loading to complete
      await tester.pump(const Duration(milliseconds: 600));

      // Check for error message
      expect(find.text('Invalid email or password. Please try again.'), findsOneWidget);
    });

    testWidgets('Login with valid credentials navigates to home', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
          routes: {
            '/home': (context) => const Scaffold(body: Text('Home Page')),
          },
        ),
      );

      // Enter valid credentials
      final emailField = find.widgetWithText(TextFormField, 'Enter your email');
      await tester.enterText(emailField, 'admin');

      final passwordField = find.widgetWithText(TextFormField, 'Enter your password');
      await tester.enterText(passwordField, 'admin');

      // Tap submit
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      await tester.tap(submitButton);
      await tester.pump();
      
      // Wait for loading to complete
      await tester.pump(const Duration(milliseconds: 600));

      // Check if navigated to home page
      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('Loading indicator shows during login', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
          routes: {
            '/home': (context) => const Scaffold(body: Text('Home Page')),
          },
        ),
      );

      // Enter valid credentials
      final emailField = find.widgetWithText(TextFormField, 'Enter your email');
      await tester.enterText(emailField, 'admin');

      final passwordField = find.widgetWithText(TextFormField, 'Enter your password');
      await tester.enterText(passwordField, 'admin');

      // Tap submit
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      await tester.tap(submitButton);
      await tester.pump();

      // Check for loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('LoginPage Responsive Tests', () {
    testWidgets('Mobile layout is used for narrow screens', (WidgetTester tester) async {
      // Set a narrow screen size (mobile)
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // On mobile, should use SingleChildScrollView with padding
      expect(find.byType(SingleChildScrollView), findsWidgets);

      // Reset
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('Desktop layout is used for wide screens', (WidgetTester tester) async {
      // Set a wide screen size (desktop)
      tester.view.physicalSize = const Size(1600, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // On desktop, should use Row for split layout
      expect(find.byType(Row), findsWidgets);

      // Reset
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
