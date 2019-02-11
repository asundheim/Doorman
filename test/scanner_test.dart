import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/scanner.dart';

void main() {
  testWidgets('Scanner should error properly', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(

          home: Scanner()
        )
    );
    await tester.tap(find.byType(RaisedButton));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('User pressed the back button'), findsOneWidget);
  });
}