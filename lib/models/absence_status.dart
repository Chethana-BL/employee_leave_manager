enum AbsenceStatus { requested, confirmed, rejected }

extension AbsenceStatusExtension on AbsenceStatus {
  String get label {
    switch (this) {
      case AbsenceStatus.requested:
        return 'Requested';
      case AbsenceStatus.confirmed:
        return 'Confirmed';
      case AbsenceStatus.rejected:
        return 'Rejected';
    }
  }

  static AbsenceStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AbsenceStatus.confirmed;
      case 'rejected':
        return AbsenceStatus.rejected;
      case 'requested':
      default:
        return AbsenceStatus.requested;
    }
  }
}
