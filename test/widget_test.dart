import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/main.dart';

void main() {
  testWidgets('Toggle theme test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the initial theme is light.
    expect(Theme.of(tester.element(find.byType(MaterialApp))).brightness, Brightness.light);

    // Tap on the lightbulb icon to toggle theme.
    await tester.tap(find.byIcon(Icons.lightbulb_outline));
    await tester.pump();

    // Verify that the theme is now dark.
    expect(Theme.of(tester.element(find.byType(MaterialApp))).brightness, Brightness.dark);
  });
}
