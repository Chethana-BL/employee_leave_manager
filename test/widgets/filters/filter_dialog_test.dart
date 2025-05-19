import 'package:employee_leave_manager/models/absence_status.dart';
import 'package:employee_leave_manager/models/absence_type.dart';
import 'package:employee_leave_manager/models/filters/absence_filter_model.dart';
import 'package:employee_leave_manager/models/member.dart';
import 'package:employee_leave_manager/widgets/filters/filter_date_selector.dart';
import 'package:employee_leave_manager/widgets/filters/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  // Mock data
  final mockMembers = [
    Member(id: 1, crewId: 11, userId: 12, image: '', name: 'Alice'),
    Member(id: 2, crewId: 11, userId: 13, image: '', name: 'Bob'),
  ];

  AbsenceFilterModel createFilter({
    AbsenceType? type,
    AbsenceStatus? status,
    Member? employee,
    DateTimeRange? dateRange,
  }) {
    return AbsenceFilterModel(
      type: type,
      status: status,
      employee: employee,
      dateRange: dateRange,
    );
  }

  group('FilterDialog Widget Tests', () {
    testWidgets('renders with initial data and basic UI elements',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterDialog(
              initialFilters: createFilter(),
              allMembers: mockMembers,
              onApply: (_) {},
              onClear: () {},
            ),
          ),
        ),
      );

      expect(find.text('Filters'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);
      expect(find.text('All'), findsNWidgets(3)); // Dropdowns default to All
    });

    testWidgets('can select dropdown values and apply filters', (tester) async {
      AbsenceFilterModel? appliedFilter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterDialog(
              initialFilters: createFilter(),
              allMembers: mockMembers,
              onApply: (filter) {
                appliedFilter = filter;
              },
              onClear: () {},
            ),
          ),
        ),
      );

      // Select Leave Type
      await tester.tap(find.text('All').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(AbsenceType.values.first.label).last);
      await tester.pumpAndSettle();

      // Select Status
      await tester.tap(find.text('All').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(AbsenceStatus.values.first.label).last);
      await tester.pumpAndSettle();

      // Select Employee
      await tester.tap(find.text('All').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(mockMembers.first.name).last);
      await tester.pumpAndSettle();

      // Press Apply and verify filters
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(appliedFilter, isNotNull);
      expect(appliedFilter!.type, AbsenceType.values.first);
      expect(appliedFilter!.status, AbsenceStatus.values.first);
      expect(appliedFilter!.employee, mockMembers.first);
    });

    testWidgets('clears all filters when Clear All button is tapped',
        (tester) async {
      bool cleared = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterDialog(
              initialFilters: createFilter(
                type: AbsenceType.vacation,
                status: AbsenceStatus.confirmed,
                employee: mockMembers.first,
              ),
              allMembers: mockMembers,
              onApply: (_) {},
              onClear: () {
                cleared = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();

      expect(cleared, isTrue);
    });

    testWidgets('FilterDateSelector clears selectedRange when Clear is tapped',
        (tester) async {
      // Initial date range to start with
      final initialDateRange = DateTimeRange(
        start: DateTime(2023, 1, 1),
        end: DateTime(2023, 1, 5),
      );

      // Initial filters include the initial date range
      final initialFilters = AbsenceFilterModel(dateRange: initialDateRange);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterDialog(
              initialFilters: initialFilters,
              allMembers: [],
              onApply: (_) {},
              onClear: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FilterDateSelector), findsOneWidget);

      // Verify the date range text is displayed in FilterDateSelector button
      final formattedStart =
          DateFormat('MMM d, yyyy').format(initialDateRange.start);
      final formattedEnd =
          DateFormat('MMM d, yyyy').format(initialDateRange.end);
      expect(find.text('$formattedStart to $formattedEnd'), findsOneWidget);

      // The Clear button inside FilterDateSelector should be visible
      final clearButton = find.widgetWithText(TextButton, 'Clear');
      expect(clearButton, findsOneWidget);

      // Tap Clear button inside FilterDateSelector
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Now the dateRange inside FilterDialog's _filters should be null
      // The displayed button text changes to 'Select Date Range'
      expect(find.text('Select Date Range'), findsOneWidget);
      expect(find.text('$formattedStart to $formattedEnd'), findsNothing);
    });
  });
}
