import 'package:employee_leave_manager/repository/absence_repository_factory.dart';
import 'package:employee_leave_manager/repository/api_absence_repository.dart';
import 'package:employee_leave_manager/repository/mock_absence_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AbsenceRepositoryFactory', () {
    test('creates MockAbsenceRepository when type is mock', () {
      final repo = AbsenceRepositoryFactory.create(DataSourceType.mock);
      expect(repo, isA<MockAbsenceRepository>());
    });

    test('creates ApiAbsenceRepository when type is api', () {
      final repo = AbsenceRepositoryFactory.create(DataSourceType.api);
      expect(repo, isA<ApiAbsenceRepository>());
    });
  });
}
