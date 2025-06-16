// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nutrisafe/main.dart';

void main() {
  testWidgets('Home screen displays action buttons', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NutriSafeApp());

    // Allow any asynchronous operations to complete.
    await tester.pumpAndSettle();

    // Verify that home screen widgets are present.
    expect(find.text('Scan Label'), findsOneWidget);
    expect(find.text('Manual Input'), findsOneWidget);
  });
}
