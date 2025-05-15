import 'absence_status.dart';
import 'absence_type.dart';
import 'member.dart';

/// Absence class represents an absence request made by an employee.
class Absence {
  Absence({
    required this.id,
    required this.userId,
    this.memberNote,
    this.admitterNote,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.confirmedAt,
    this.rejectedAt,
    required this.member,
    required this.status,
  });

  factory Absence.fromJson(Map<String, dynamic> json, Member member) {
    final type =
        AbsenceTypeExtension.fromString(json['type']) ?? AbsenceType.vacation;

    return Absence(
      id: json['id'] as int,
      userId: json['userId'] as int,
      memberNote: json['memberNote'] as String?,
      admitterNote: json['admitterNote'] as String?,
      startDate: DateTime.tryParse(json['startDate']) ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate']) ?? DateTime.now(),
      type: type,
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.tryParse(json['confirmedAt'])
          : null,
      rejectedAt: json['rejectedAt'] != null
          ? DateTime.tryParse(json['rejectedAt'])
          : null,
      member: member,
      status: _determineStatus(json),
    );
  }

  final int id;
  final int userId;
  final String? memberNote;
  final String? admitterNote;
  final DateTime startDate;
  final DateTime endDate;
  final AbsenceType type;
  final DateTime? confirmedAt;
  final DateTime? rejectedAt;
  final Member member;
  final AbsenceStatus status;

  /// Returns absence status inferred from 'confirmedAt' and 'rejectedAt'
  static AbsenceStatus _determineStatus(Map<String, dynamic> json) {
    if (json['confirmedAt'] != null) return AbsenceStatus.confirmed;
    if (json['rejectedAt'] != null) return AbsenceStatus.rejected;
    return AbsenceStatus.requested;
  }
}
