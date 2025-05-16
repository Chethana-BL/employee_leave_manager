import 'package:equatable/equatable.dart';

abstract class AbsenceEvent extends Equatable {
  const AbsenceEvent();

  @override
  List<Object?> get props => [];
}

/// LoadAbsences: Event to load absences.
/// This event is triggered when the user wants to load a specific page of absences.
class LoadAbsences extends AbsenceEvent {
  const LoadAbsences({
    required this.page,
  });
  final int page;

  @override
  List<Object?> get props => [page];
}
