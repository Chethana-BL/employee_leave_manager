enum AbsenceType { vacation, sickness }

extension AbsenceTypeExtension on AbsenceType {
  String get label {
    switch (this) {
      case AbsenceType.vacation:
        return 'Vacation';
      case AbsenceType.sickness:
        return 'Sickness';
    }
  }

  static AbsenceType? fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'vacation':
        return AbsenceType.vacation;
      case 'sickness':
        return AbsenceType.sickness;
      default:
        return null;
    }
  }
}
