import 'package:employee_leave_manager/models/member.dart';
import 'package:employee_leave_manager/repository/absence_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Initialize the test environment for Flutter.
  TestWidgetsFlutterBinding.ensureInitialized();

  late AbsenceRepository repository;

  setUp(() {
    repository = AbsenceRepository();
  });

  group('AbsenceRepository', () {
    test('Each member has required keys', () async {
      final members = await repository.fetchMembers();
      for (final member in members) {
        expect(member.id, isNotNull);
        expect(member.userId, isNotNull);
        expect(member.name, isNotEmpty);
        expect(member.image, isNotEmpty);
      }
    });

    test('Each absence has required keys and is linked to a member', () async {
      final absences = await repository.fetchAbsences();

      for (final absence in absences) {
        expect(absence.id, isNotNull);
        expect(absence.userId, isNotNull);
        expect(absence.startDate, isA<DateTime>());
        expect(absence.endDate, isA<DateTime>());
        expect(absence.type, isNotNull);
        expect(absence.member, isA<Member>());

        // Additional: Ensure the member for this absence matches the userId
        expect(absence.member.userId, absence.userId);
      }
    });
  });
}
