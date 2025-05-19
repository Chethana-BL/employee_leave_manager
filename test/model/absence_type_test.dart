import 'package:employee_leave_manager/models/absence_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AbsenceTypeExtension', () {
    test('label returns correct string for each type', () {
      expect(AbsenceType.vacation.label, 'Vacation');
      expect(AbsenceType.sickness.label, 'Sickness');
    });

    test('fromString returns correct AbsenceType for known values', () {
      expect(AbsenceTypeExtension.fromString('vacation'), AbsenceType.vacation);
      expect(AbsenceTypeExtension.fromString('Vacation'), AbsenceType.vacation);
      expect(AbsenceTypeExtension.fromString('sickness'), AbsenceType.sickness);
      expect(AbsenceTypeExtension.fromString('SICKNESS'), AbsenceType.sickness);
    });

    test('fromString returns null for unknown or null values', () {
      expect(AbsenceTypeExtension.fromString('other'), isNull);
      expect(AbsenceTypeExtension.fromString(''), isNull);
      expect(AbsenceTypeExtension.fromString(null), isNull);
    });
  });
}
