import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/absence.dart';
import '../models/absence_status.dart';
import '../models/absence_type.dart';
import '../models/member.dart';

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
    this.typeFilter,
    this.statusFilter,
    this.memberFilter,
    this.dateRangeFilter,
  });
  final List<Absence> currentPageAbsences;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int fromIndex;
  final int toIndex;
  final AbsenceType? typeFilter;
  final AbsenceStatus? statusFilter;
  final DateTimeRange? dateRangeFilter;
  final Member? memberFilter;

  @override
  List<Object?> get props => [
        currentPageAbsences,
        currentPage,
        totalItems,
        fromIndex,
        toIndex,
        typeFilter,
        statusFilter,
        dateRangeFilter,
      ];
}

class AbsenceError extends AbsenceState {
  const AbsenceError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
