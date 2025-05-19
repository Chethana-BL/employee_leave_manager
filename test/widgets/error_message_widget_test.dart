import 'package:employee_leave_manager/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'displays error message without retry button when onRetry is null',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ErrorMessageWidget(),
        ),
      ),
    );

    expect(find.text('Oops! Something went wrong. Please try again.'),
        findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsNothing);
  });

  testWidgets('displays retry button and triggers callback when pressed',
      (WidgetTester tester) async {
    var retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorMessageWidget(
            onRetry: () {
              retried = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Oops! Something went wrong. Please try again.'),
        findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(retried, isTrue);
  });
}
