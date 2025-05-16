import '../models/absence.dart';
import '../models/member.dart';
import 'absence_repository.dart';

/// Implementation of AbsenceRepository that fetches data from an API.
/// TODO: This is a placeholder implementation and should be replaced with actual API calls.
class ApiAbsenceRepository implements AbsenceRepository {
  @override
  Future<List<Absence>> fetchAbsences() async {
    // TODO: Implement real API call
    throw UnimplementedError('API fetchAbsences not implemented yet');
  }

  @override
  Future<List<Member>> fetchMembers() async {
    // TODO: Implement real API call
    throw UnimplementedError('API fetchMembers not implemented yet');
  }
}
