import 'package:employee_leave_manager/models/absence.dart';
import 'package:employee_leave_manager/models/absence_type.dart';
import 'package:employee_leave_manager/models/member.dart';
import 'package:employee_leave_manager/repository/mock_absence_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  /// Initialize the test environment for Flutter.
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAbsenceRepository repository;

  setUp(() {
    repository = MockAbsenceRepository();
  });

  group('MockAbsenceRepository: Data integrity', () {
    test('Each absence has required keys', () async {
      final absences = await repository.fetchAbsences();
      for (final absence in absences) {
        expect(absence.id, isNotNull);
        expect(absence.userId, isNotNull);
        expect(absence.startDate, isA<DateTime>());
        expect(absence.endDate, isA<DateTime>());
        expect(absence.type, isA<AbsenceType>());
        expect(absence.member, isA<Member>());
      }
    });
    test('Each member has required keys', () async {
      final members = await repository.fetchMembers();
      for (final member in members) {
        expect(member.id, isA<int>());
        expect(member.userId, isA<int>());
        expect(member.name, isA<String>());
        expect(member.image, isA<String>());
        expect(member.crewId, isA<int>());
      }
    });
  });

  group('MockAbsenceRepository: Data validation', () {
    test('fetchMembers returns list of Member objects', () async {
      final members = await repository.fetchMembers();

      expect(members, isA<List<Member>>());
      expect(members.length, 10);
      expect(members.first.name, 'Max');
      expect(members.first.userId, 644);
    });

    test('fetchAbsences returns list of Absence objects linked to members',
        () async {
      final absences = await repository.fetchAbsences();

      expect(absences, isA<List<Absence>>());
      expect(absences.length, 42);
      expect(absences.first.member.name, 'Mike');
      expect(absences.first.type.label, 'Sickness');
    });
  });
}
