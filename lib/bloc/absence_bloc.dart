import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/absence.dart';
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
      LoadAbsences event, Emitter<AbsenceState> emit) async {
    emit(AbsenceLoading());

    try {
      /// Load data only once if not loaded yet
      if (_allAbsences.isEmpty) {
        _allAbsences = await repository.fetchAbsences();
      }

      /// Pagination
      final totalPages = (_allAbsences.length / pageSize).ceil();
      final start = event.page * pageSize;
      final end = (start + pageSize).clamp(0, _allAbsences.length);
      final pageAbsences = _allAbsences.sublist(start, end);

      emit(AbsenceLoaded(
        currentPageAbsences: pageAbsences,
        currentPage: event.page,
        totalPages: totalPages,
        totalItems: _allAbsences.length,
        fromIndex: start + 1,
        toIndex: end,
      ));
    } catch (e) {
      emit(AbsenceError('Failed to load absences: $e'));
    }
  }
}
