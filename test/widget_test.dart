// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:app_p_134/dependencies.dart';
import 'package:app_p_134/core/database/local_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App launches without error', (WidgetTester tester) async {
    // Initialize SharedPreferences for tests
    SharedPreferences.setMockInitialValues({});
    
    // Initialize LocalData
    await LocalData.initLocalService();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Application());

    // Verify that the app builds without error
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Wait for initial navigation
    await tester.pump(const Duration(seconds: 4));
    
    // The app should navigate to welcome screen on first launch
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
