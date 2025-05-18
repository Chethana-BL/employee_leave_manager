import '../models/absence.dart';
import '../models/absence_status.dart';
import '../models/absence_type.dart';

/// Abstract class for exporting absences to iCal format.
/// This class provides a method to generate iCal content from a list of absences.
abstract class ICalExportService {
  Future<void> exportAbsencesToICal(List<Absence> absences);

  String generateICalContent(List<Absence> absences) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCALENDAR');
    buffer.writeln('VERSION:2.0');
    buffer.writeln('PRODID:-//AbsenceApp//EN');

    for (final absence in absences) {
      buffer.writeln('BEGIN:VEVENT');
      buffer.writeln('UID:${absence.id}@absenceapp');
      buffer.writeln('DTSTAMP:${formatDate(DateTime.now())}');
      buffer.writeln('DTSTART:${formatDate(absence.startDate)}');
      buffer.writeln('DTEND:${formatDate(absence.endDate)}');
      buffer.writeln('SUMMARY:${absence.type.label} - ${absence.member.name}');
      buffer.writeln('DESCRIPTION:${absence.memberNote ?? 'No note'}');
      buffer.writeln('STATUS:${absence.status.label}');
      buffer.writeln('END:VEVENT');
    }

    buffer.writeln('END:VCALENDAR');
    return buffer.toString();
  }

  String formatDate(DateTime dt) {
    return '${dt.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
  }
}
