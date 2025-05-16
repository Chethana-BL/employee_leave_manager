import 'absence.dart';

/// PaginatedAbsenceResult class represents a paginated result of absences.
/// Consists of the list of absences for the current page, the range of indices.
class PaginatedAbsenceResult {
  PaginatedAbsenceResult({
    required this.pageAbsences,
    required this.fromIndex,
    required this.toIndex,
    required this.totalPages,
  });

  final List<Absence> pageAbsences;
  final int fromIndex;
  final int toIndex;
  final int totalPages;
}
