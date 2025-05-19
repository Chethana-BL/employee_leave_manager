import 'package:employee_leave_manager/widgets/absence_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AbsenceOverview displays correct range and icon',
      (WidgetTester tester) async {
    // Arrange test input values
    const fromIndex = 1;
    const toIndex = 10;
    const totalItems = 50;

    // Act: pump the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AbsenceOverview(
            fromIndex: fromIndex,
            toIndex: toIndex,
            totalItems: totalItems,
          ),
        ),
      ),
    );

    // Assert: Verify the icon is present
    expect(find.byIcon(Icons.analytics_outlined), findsOneWidget);

    // Assert: Verify the correct text is rendered
    expect(
      find.text('Absences listed: $fromIndex–$toIndex of $totalItems'),
      findsOneWidget,
    );
  });
}
