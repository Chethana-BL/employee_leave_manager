import 'package:employee_leave_manager/models/absence.dart';
import 'package:employee_leave_manager/models/absence_status.dart';
import 'package:employee_leave_manager/models/absence_type.dart';
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

  group('Absence.fromJson - member note logic', () {
    final dummyMember = Member(
      id: 1,
      userId: 1,
      crewId: 1,
      name: 'Test User',
      image: '',
    );

    test('returns null when memberNote is not present', () {
      final json = {
        'id': 4,
        'userId': 1,
        'startDate': '2024-01-01',
        'endDate': '2024-01-05',
        'type': 'vacation',
        'confirmedAt': null,
        'rejectedAt': null,
        'admitterNote': null,
      };

      final absence = Absence.fromJson(json, dummyMember);

      expect(absence.memberNote, isNull);
    });

    test('returns memberNote when present', () {
      final json = {
        'id': 5,
        'userId': 1,
        'startDate': '2024-01-01',
        'endDate': '2024-01-05',
        'type': 'vacation',
        'confirmedAt': null,
        'rejectedAt': null,
        'memberNote': "I'm sick",
        'admitterNote': null,
      };

      final absence = Absence.fromJson(json, dummyMember);

      expect(absence.memberNote, "I'm sick");
    });
  });

  group('Absence.fromJson - admitter note logic', () {
    final dummyMember = Member(
      id: 1,
      userId: 1,
      crewId: 1,
      name: 'Test User',
      image: '',
    );

    test('returns null when admitterNote is not present', () {
      final json = {
        'id': 6,
        'userId': 1,
        'startDate': '2024-01-01',
        'endDate': '2024-01-05',
        'type': 'vacation',
        'confirmedAt': null,
        'rejectedAt': null,
        'memberNote': null,
      };

      final absence = Absence.fromJson(json, dummyMember);

      expect(absence.admitterNote, isNull);
    });

    test('returns admitterNote when present', () {
      final json = {
        'id': 7,
        'userId': 1,
        'startDate': '2024-01-01',
        'endDate': '2024-01-05',
        'type': 'vacation',
        'confirmedAt': null,
        'rejectedAt': null,
        'memberNote': null,
        'admitterNote': 'Approved',
      };

      final absence = Absence.fromJson(json, dummyMember);

      expect(absence.admitterNote, 'Approved');
    });
  });
  group('Absence.fromJson - type logic', () {
    final dummyMember = Member(
      id: 1,
      userId: 1,
      crewId: 1,
      name: 'Test User',
      image: '',
    );

    test('returns AbsenceType.vacation when type is "vacation"', () {
      final json = {
        'id': 8,
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

      expect(absence.type, AbsenceType.vacation);
    });

    test('returns AbsenceType.sickness when type is "sickness"', () {
      final json = {
        'id': 9,
        'userId': 1,
        'startDate': '2024-01-01',
        'endDate': '2024-01-05',
        'type': 'sickness',
        'confirmedAt': null,
        'rejectedAt': null,
        'memberNote': null,
        'admitterNote': null,
      };

      final absence = Absence.fromJson(json, dummyMember);

      expect(absence.type, AbsenceType.sickness);
    });
  });
}
