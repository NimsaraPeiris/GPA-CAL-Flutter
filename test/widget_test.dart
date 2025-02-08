// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:GPA_CALCULATOR/main.dart';

void main() {
  testWidgets('GPA Calculator initial state test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GPACalculatorApp());

    // Verify that initial elements are present
    expect(find.text('GPA Calculator'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
    expect(find.byType(DropdownButtonFormField<String>), findsWidgets);
    expect(
        find.widgetWithText(ElevatedButton, 'Calculate GPA'), findsOneWidget);
  });
}
