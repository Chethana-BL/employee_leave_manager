import 'package:employee_leave_manager/models/absence.dart';
import 'package:employee_leave_manager/models/absence_status.dart';
import 'package:employee_leave_manager/models/member.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Absence.fromJson - determine status logic', () {
    final dummyMember = Member(
      id: 1,
      userId: 1,
      crewId: 1,
      name: 'Test User',
      image: '',
    );

    test('returns AbsenceStatus.confirmed when confirmedAt is present', () {
      final json = {
        'id': 1,
        'userId': 1,
        'startDate': '2024-01-01',
        'endDate': '2024-01-05',
        'type': 'vacation',
        'confirmedAt': '2024-01-02T10:00:00Z',
        'rejectedAt': null,
        'memberNote': null,
        'admitterNote': null,
      };

      final absence = Absence.fromJson(json, dummyMember);

      expect(absence.status, AbsenceStatus.confirmed);
    });

    test('returns AbsenceStatus.rejected when rejectedAt is present', () {
      final json = {
        'id': 2,
        'userId': 1,
        'startDate': '2024-01-01',
        'endDate': '2024-01-05',
        'type': 'vacation',
        'confirmedAt': null,
        'rejectedAt': '2024-01-02T10:00:00Z',
        'memberNote': null,
        'admitterNote': null,
      };

      final absence = Absence.fromJson(json, dummyMember);

      expect(absence.status, AbsenceStatus.rejected);
    });

    test('returns AbsenceStatus.requested when both are null', () {
      final json = {
        'id': 3,
        'userId': 1,
        'startDate': '2024-01-01',
        'endDate': '2024-01-05',
        'type': 'vacation',
        'confirmedAt': null,
        'rejectedAt': null,
        'memberNote': null,
        'admitterNote': null,
      };

      final absence = Absence.fromJson(json, dummyMember);

      expect(absence.status, AbsenceStatus.requested);
    });
  });
}
