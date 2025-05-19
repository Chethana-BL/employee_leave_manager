import 'package:employee_leave_manager/widgets/no_absences_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NoAbsencesFound displays icon and messages',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NoAbsencesFound(),
        ),
      ),
    );

    // Verify the icon
    final iconFinder = find.byIcon(Icons.event_busy);
    expect(iconFinder, findsOneWidget);

    // Verify the primary message
    expect(find.text('No absences found.'), findsOneWidget);

    // Verify the secondary message
    expect(
      find.text('Try adjusting your filters or check back later.'),
      findsOneWidget,
    );
  });
}
