import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_absensi_app/screens/login_screen.dart';

void main() {
  group('LoginScreen Tests', () {
    testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
      // Build the LoginScreen widget
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Verify that key elements are present
      expect(find.text('Login to Simporter'), findsOneWidget);
      expect(find.text('LOGIN'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Forgot your password?'), findsOneWidget);
    });

    testWidgets('Password field toggles visibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Find the password field
      final passwordField = find.byType(TextFormField).last;
      expect(passwordField, findsOneWidget);

      // Find the visibility toggle button
      final toggleButton = find.byIcon(Icons.visibility_off);
      expect(toggleButton, findsOneWidget);

      // Tap the toggle button
      await tester.tap(toggleButton);
      await tester.pump();

      // Verify the icon changed to visibility
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Shows error for empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Tap the login button without entering credentials
      await tester.tap(find.text('LOGIN'));
      await tester.pump();

      // Verify validation error messages appear
      expect(find.text('Please enter your username'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Shows error for incorrect credentials', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
          routes: {
            '/main': (context) => const Scaffold(body: Text('Main Screen')),
          },
        ),
      );

      // Enter incorrect credentials
      await tester.enterText(find.byType(TextFormField).first, 'wronguser');
      await tester.enterText(find.byType(TextFormField).last, 'wrongpass');

      // Tap the login button
      await tester.tap(find.text('LOGIN'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Verify error message appears
      expect(find.text('Invalid username or password'), findsOneWidget);
    });

    testWidgets('Navigates to main screen on successful login', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
          routes: {
            '/main': (context) => const Scaffold(body: Text('Main Screen')),
          },
        ),
      );

      // Enter correct credentials
      await tester.enterText(find.byType(TextFormField).first, 'admin');
      await tester.enterText(find.byType(TextFormField).last, 'admin');

      // Tap the login button
      await tester.tap(find.text('LOGIN'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Verify navigation to main screen
      expect(find.text('Main Screen'), findsOneWidget);
    });
  });
}
