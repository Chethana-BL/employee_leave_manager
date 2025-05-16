import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/absence.dart';
import '../models/paginated_result.dart';
import '../repository/absence_repository.dart';
import 'absence_event.dart';
import 'absence_state.dart';

class AbsenceBloc extends Bloc<AbsenceEvent, AbsenceState> {
  AbsenceBloc({
    required this.repository,
    this.pageSize = 10,
  }) : super(AbsenceInitial()) {
    on<LoadAbsences>(_onLoadAbsences);
  }
  final AbsenceRepository repository;
  final int pageSize;

  List<Absence> _allAbsences = [];

  Future<void> _onLoadAbsences(
    LoadAbsences event,
    Emitter<AbsenceState> emit,
  ) async {
    emit(AbsenceLoading());

    try {
      /// Load data only once if not loaded yet
      if (_allAbsences.isEmpty) {
        _allAbsences = await repository.fetchAbsences();
      }

      // Apply filters
      final filteredAbsences = _applyFilters(_allAbsences, event);

      // Paginate
      final paginatedData = _paginateAbsences(filteredAbsences, event.page);

      emit(AbsenceLoaded(
        currentPageAbsences: paginatedData.pageAbsences,
        currentPage: event.page,
        totalPages: paginatedData.totalPages,
        totalItems: filteredAbsences.length,
        fromIndex: paginatedData.fromIndex,
        toIndex: paginatedData.toIndex,
        typeFilter: event.typeFilter,
        statusFilter: event.statusFilter,
        dateRangeFilter: event.dateRangeFilter,
      ));
    } catch (e) {
      emit(AbsenceError('Failed to load absences: $e'));
    }
  }

  /// Apply filters to the list of absences based on the provided event.
  /// Returns a filtered list of [Absences].
  List<Absence> _applyFilters(List<Absence> absences, LoadAbsences event) {
    var filtered = [...absences];

    if (event.typeFilter != null) {
      filtered = filtered.where((a) => a.type == event.typeFilter).toList();
    }

    if (event.statusFilter != null) {
      filtered = filtered.where((a) => a.status == event.statusFilter).toList();
    }

    if (event.memberFilter != null) {
      filtered = filtered
          .where((a) => a.member.userId == event.memberFilter!.userId)
          .toList();
    }

    if (event.dateRangeFilter != null) {
      filtered = filtered.where((a) {
        final start = a.startDate;
        return start.isAfter(event.dateRangeFilter!.start
                .subtract(const Duration(days: 1))) &&
            start.isBefore(
                event.dateRangeFilter!.end.add(const Duration(days: 1)));
      }).toList();
    }

    return filtered;
  }

  /// Paginate the list of absences based on the current page and page size.
  /// Returns a [PaginatedAbsenceResult] containing the absences for the current page.
  PaginatedAbsenceResult _paginateAbsences(List<Absence> absences, int page) {
    final totalCount = absences.length;
    final totalPages = (totalCount / pageSize).ceil();

    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, totalCount);
    final pageAbsences = absences.sublist(start, end);

    return PaginatedAbsenceResult(
      pageAbsences: pageAbsences,
      fromIndex: start,
      toIndex: end,
      totalPages: totalPages,
    );
  }
}
