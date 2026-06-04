// ============================================================
//  IMPILO — Widget Test
//  File: test/widget_test.dart
//
//  Replaces the default Flutter counter test.
//  Tests that the SplashScreen renders correctly.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:impilo/main.dart';

void main() {
  testWidgets('Impilo splash screen renders app name', (WidgetTester tester) async {
    // Build the Impilo app
    await tester.pumpWidget(const ImpiloApp());

    // Let the first frame render
    await tester.pump();

    // Verify the app name appears on the splash screen
    expect(find.text('Impilo'), findsOneWidget);

    // Verify the tagline appears
    expect(
      find.text('Your life. Your journey. Your Impilo.'),
      findsOneWidget,
    );
  });
}