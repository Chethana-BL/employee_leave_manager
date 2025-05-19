import 'package:employee_leave_manager/models/absence_status.dart';
import 'package:employee_leave_manager/models/absence_type.dart';
import 'package:employee_leave_manager/models/filters/absence_filter_model.dart';
import 'package:employee_leave_manager/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AbsenceFilterModel', () {
    final member = Member(
      crewId: 1,
      id: 1,
      image: 'https://example.com/image.jpg',
      name: 'John Doe',
      userId: 101,
    );

    final range = DateTimeRange(
      start: DateTime(2024, 1, 1),
      end: DateTime(2024, 1, 5),
    );

    test('initializes with given values', () {
      final model = AbsenceFilterModel(
        type: AbsenceType.vacation,
        status: AbsenceStatus.confirmed,
        employee: member,
        dateRange: range,
      );

      expect(model.type, AbsenceType.vacation);
      expect(model.status, AbsenceStatus.confirmed);
      expect(model.employee, member);
      expect(model.dateRange, range);
    });

    test('activeCount returns correct number of active filters', () {
      final model = AbsenceFilterModel(
        type: AbsenceType.sickness,
        status: null,
        employee: member,
        dateRange: null,
      );

      expect(model.activeCount, 2);
    });

    test('clear sets all filters to null', () {
      final model = AbsenceFilterModel(
        type: AbsenceType.vacation,
        status: AbsenceStatus.rejected,
        employee: member,
        dateRange: range,
      );

      model.clear();

      expect(model.type, isNull);
      expect(model.status, isNull);
      expect(model.employee, isNull);
      expect(model.dateRange, isNull);
      expect(model.activeCount, 0);
    });

    test('copy returns a new instance with same values', () {
      final original = AbsenceFilterModel(
        type: AbsenceType.vacation,
        status: AbsenceStatus.requested,
        employee: member,
        dateRange: range,
      );

      final copied = original.copy();

      expect(copied, isNot(same(original))); // Different objects
      expect(copied.type, original.type);
      expect(copied.status, original.status);
      expect(copied.employee, original.employee);
      expect(copied.dateRange, original.dateRange);
    });
  });
}
