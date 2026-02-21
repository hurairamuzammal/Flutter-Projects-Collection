// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:torch/main.dart';

void main() {
  testWidgets('Enhanced torch app loads and shows basic UI', (tester) async {
    // Disable hardware calls in tests
    enableTorchHardware = false;

    await tester.pumpWidget(const TorchApp());
    await tester.pumpAndSettle();

    // Should show current mode indicator (initially "Torch")
    expect(find.text('Torch'), findsOneWidget);

    // Initially shows OFF
    expect(find.text('OFF'), findsOneWidget);

    // Main button should be present
    expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));

    // Expandable menu FAB should be present
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Mode menu expands and collapses', (tester) async {
    enableTorchHardware = false;

    await tester.pumpWidget(const TorchApp());
    await tester.pumpAndSettle();

    // Initially mode buttons should not be visible
    expect(find.text('Strobe'), findsNothing);
    expect(find.text('Screen'), findsNothing);

    // Tap the menu button to expand
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Now mode buttons should be visible
    expect(find.text('Strobe'), findsOneWidget);
    expect(find.text('Screen'), findsOneWidget);

    // Tap Strobe to switch mode
    await tester.tap(find.text('Strobe'));
    await tester.pumpAndSettle();

    // Mode indicator should now show "Strobe"
    expect(find.text('Strobe'), findsOneWidget);
  });
}
