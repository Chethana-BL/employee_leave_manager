import 'dart:convert';
import 'dart:io';

import 'package:employee_leave_manager/models/absence.dart';
import 'package:employee_leave_manager/models/absence_status.dart';
import 'package:employee_leave_manager/models/absence_type.dart';
import 'package:employee_leave_manager/models/member.dart';
import 'package:employee_leave_manager/services/ical_export_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDirectory extends Fake implements Directory {
  @override
  String get path => '/mock/path';
}

class MockFile extends Fake implements File {
  String writtenContent = '';

  @override
  Future<File> writeAsString(
    String contents, {
    Encoding encoding = utf8,
    bool flush = false,
    FileMode mode = FileMode.write,
  }) async {
    // Simulate file write and return a mock file reference
    return this;
  }

  @override
  String get path => '/mock/path/absences_20250516T120000.ics';
}

void main() {
  late ICalExportService exportService;

  setUpAll(() {
    registerFallbackValue(MockDirectory());
    registerFallbackValue(MockFile());
  });

  setUp(() {
    exportService = ICalExportService();
  });

  group('ICalExportService', () {
    test('should generate correct iCal content for a single absence', () {
      final absence = Absence(
        id: 1,
        userId: 100,
        startDate: DateTime.utc(2025, 6, 10, 9),
        endDate: DateTime.utc(2025, 6, 10, 17),
        type: AbsenceType.vacation,
        member: Member(
          id: 1,
          userId: 1,
          crewId: 1,
          name: 'Test User 1',
          image: '',
        ),
        memberNote: 'Family vacation',
        admitterNote: null,
        confirmedAt: null,
        rejectedAt: null,
        status: AbsenceStatus.requested,
      );

      final ics = exportService.generateICalContent([absence]);

      expect(ics, contains('BEGIN:VEVENT'));
      expect(ics, contains('SUMMARY:Vacation - Test User 1'));
      expect(ics, contains('DESCRIPTION:Family vacation'));
      expect(ics, contains('STATUS:Requested'));
      expect(ics, contains('END:VEVENT'));
    });

    test('should generate multiple VEVENTS for multiple absences', () {
      final absences = List.generate(2, (index) {
        return Absence(
          id: index,
          userId: index,
          startDate: DateTime.utc(2025, 6, 10 + index, 9),
          endDate: DateTime.utc(2025, 6, 10 + index, 17),
          type: AbsenceType.sickness,
          member: Member(
            id: 2,
            userId: 2,
            crewId: 1,
            name: 'Test User 2',
            image: '',
          ),
          memberNote: null,
          admitterNote: null,
          confirmedAt: null,
          rejectedAt: null,
          status: AbsenceStatus.requested,
        );
      });

      final ics = exportService.generateICalContent(absences);

      expect(RegExp('BEGIN:VEVENT').allMatches(ics).length, equals(2));
    });

    test('should format datetime in UTC iCal format', () {
      final now = DateTime.utc(2025, 5, 16, 12, 0);
      final formatted = exportService.formatDate(now);

      expect(formatted, equals('20250516T120000Z'));
    });
  });
}
