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
  testWidgets('Home screen displays action cards', (WidgetTester tester) async {
    // Build the NutriSafe app and trigger a frame.
    await tester.pumpWidget(const NutriSafeApp());
    await tester.pumpAndSettle();

    // Verify that key texts on the home screen are present.
    expect(find.text('Nutrition Safety Scanner'), findsOneWidget);
    expect(find.text('Scan Label'), findsOneWidget);
    expect(find.text('Manual Input'), findsOneWidget);
  });
}
