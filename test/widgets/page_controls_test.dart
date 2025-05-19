import 'package:employee_leave_manager/widgets/page_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PageControls shows correct page text and button states',
      (tester) async {
    int nextPageCalls = 0;
    int prevPageCalls = 0;

    // Define callbacks
    void onNext() => nextPageCalls++;
    void onPrevious() => prevPageCalls++;

    // Build widget with currentPage=1, totalPages=3
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PageControls(
            currentPage: 1,
            totalPages: 3,
            onNextPage: onNext,
            onPreviousPage: onPrevious,
          ),
        ),
      ),
    );

    // Verify page text
    expect(find.text('Page 2 of 3'), findsOneWidget);

    // Both buttons should be enabled
    final backButton = find.widgetWithIcon(IconButton, Icons.arrow_back);
    final forwardButton = find.widgetWithIcon(IconButton, Icons.arrow_forward);

    expect(tester.widget<IconButton>(backButton).onPressed, isNotNull);
    expect(tester.widget<IconButton>(forwardButton).onPressed, isNotNull);

    // Tap back button and verify callback called
    await tester.tap(backButton);
    expect(prevPageCalls, 1);

    // Tap forward button and verify callback called
    await tester.tap(forwardButton);
    expect(nextPageCalls, 1);
  });

  testWidgets('Back button disabled on first page', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PageControls(
            currentPage: 0,
            totalPages: 3,
            onNextPage: () {},
            onPreviousPage: () {},
          ),
        ),
      ),
    );

    final backButton = find.widgetWithIcon(IconButton, Icons.arrow_back);
    final forwardButton = find.widgetWithIcon(IconButton, Icons.arrow_forward);

    // Back button disabled (onPressed == null)
    expect(tester.widget<IconButton>(backButton).onPressed, isNull);
    // Forward button enabled
    expect(tester.widget<IconButton>(forwardButton).onPressed, isNotNull);
  });

  testWidgets('Forward button disabled on last page', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PageControls(
            currentPage: 4,
            totalPages: 5,
            onNextPage: () {},
            onPreviousPage: () {},
          ),
        ),
      ),
    );

    final backButton = find.widgetWithIcon(IconButton, Icons.arrow_back);
    final forwardButton = find.widgetWithIcon(IconButton, Icons.arrow_forward);

    // Back button enabled
    expect(tester.widget<IconButton>(backButton).onPressed, isNotNull);
    // Forward button disabled
    expect(tester.widget<IconButton>(forwardButton).onPressed, isNull);
  });
}
