import '../models/absence.dart';
import '../models/member.dart';

/// Abstract class for AbsenceRepository.
abstract class AbsenceRepository {
  Future<List<Absence>> fetchAbsences();
  Future<List<Member>> fetchMembers();
}
