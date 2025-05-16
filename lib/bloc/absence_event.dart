import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/absence_status.dart';
import '../models/absence_type.dart';
import '../models/member.dart';

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
    this.typeFilter,
    this.statusFilter,
    this.memberFilter,
    this.dateRangeFilter,
  });
  final int page;
  final AbsenceType? typeFilter;
  final AbsenceStatus? statusFilter;
  final DateTimeRange? dateRangeFilter;
  final Member? memberFilter;

  @override
  List<Object?> get props => [
        page,
        typeFilter,
        dateRangeFilter,
        statusFilter,
        memberFilter,
      ];
}
