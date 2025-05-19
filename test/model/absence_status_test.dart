import 'package:employee_leave_manager/models/absence_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AbsenceStatusExtension', () {
    test('label returns correct string for each status', () {
      expect(AbsenceStatus.requested.label, 'Requested');
      expect(AbsenceStatus.confirmed.label, 'Confirmed');
      expect(AbsenceStatus.rejected.label, 'Rejected');
    });

    test('fromString returns correct AbsenceStatus for known values', () {
      expect(AbsenceStatusExtension.fromString('requested'),
          AbsenceStatus.requested);
      expect(AbsenceStatusExtension.fromString('Requested'),
          AbsenceStatus.requested);
      expect(AbsenceStatusExtension.fromString('confirmed'),
          AbsenceStatus.confirmed);
      expect(AbsenceStatusExtension.fromString('CONFIRMED'),
          AbsenceStatus.confirmed);
      expect(AbsenceStatusExtension.fromString('rejected'),
          AbsenceStatus.rejected);
      expect(AbsenceStatusExtension.fromString('REJECTED'),
          AbsenceStatus.rejected);
    });

    test('fromString defaults to requested for unknown input', () {
      expect(AbsenceStatusExtension.fromString('invalid'),
          AbsenceStatus.requested);
      expect(AbsenceStatusExtension.fromString(''), AbsenceStatus.requested);
    });
  });
}
