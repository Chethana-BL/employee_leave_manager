import 'absence_repository.dart';
import 'api_absence_repository.dart';
import 'mock_absence_repository.dart';

enum DataSourceType {
  mock,
  api,
}

/// Factory class to create instances of [AbsenceRepository].
class AbsenceRepositoryFactory {
  static AbsenceRepository create(DataSourceType type) {
    switch (type) {
      case DataSourceType.mock:
        return MockAbsenceRepository();
      case DataSourceType.api:
        return ApiAbsenceRepository(
            baseUrl: 'https://leave-manager-backend.onrender.com');
    }
  }
}
