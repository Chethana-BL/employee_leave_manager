import 'package:equatable/equatable.dart';

import '../models/absence.dart';

/// AbsenceState: Represents the state of the absence data in the application.
abstract class AbsenceState extends Equatable {
  const AbsenceState();

  @override
  List<Object?> get props => [];
}

class AbsenceInitial extends AbsenceState {}

class AbsenceLoading extends AbsenceState {}

class AbsenceLoaded extends AbsenceState {
  const AbsenceLoaded({
    required this.currentPageAbsences,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.fromIndex,
    required this.toIndex,
  });
  final List<Absence> currentPageAbsences;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int fromIndex;
  final int toIndex;

  @override
  List<Object?> get props => [
        currentPageAbsences,
        currentPage,
        totalItems,
        fromIndex,
        toIndex,
      ];
}

class AbsenceError extends AbsenceState {
  const AbsenceError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
