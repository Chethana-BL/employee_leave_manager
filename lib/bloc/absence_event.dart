import 'package:equatable/equatable.dart';
import '../models/filters/absence_filter_model.dart';

abstract class AbsenceEvent extends Equatable {
  const AbsenceEvent();

  @override
  List<Object?> get props => [];
}

/// LoadAbsences: Event to load absences.
/// This event is triggered when the user wants to load a specific page of absences.
/// The [filters] are used to filter the absences.
/// The [page] number is used for pagination.

class LoadAbsences extends AbsenceEvent {
  const LoadAbsences({
    required this.page,
    required this.filters,
    this.forceRefresh = false,
  });

  final int page;
  final AbsenceFilterModel filters;
  final bool forceRefresh;

  @override
  List<Object?> get props => [page, filters];
}
