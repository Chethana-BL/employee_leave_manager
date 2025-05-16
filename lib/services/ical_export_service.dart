import 'dart:io';
import 'package:employee_leave_manager/models/absence_status.dart';
import 'package:employee_leave_manager/models/absence_type.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/absence.dart';

class ICalExportService {
  /// Export multiple absence events into a single .ics file
  Future<void> exportAbsencesToICal(List<Absence> absences) async {
    final icsContent = generateICalContent(absences);
    final file = await saveToFile(icsContent);

    await SharePlus.instance.share(
      ShareParams(
        title: 'Absence Calendar',
        text: 'Here are your absences in iCal format.',
        files: [XFile(file.path)],
      ),
    );
  }

  /// Generate iCal content with multiple events
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

  Future<File> saveToFile(String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMddTHHmmss').format(DateTime.now());
    final filePath = '${directory.path}/absences_$timestamp.ics';
    final file = File(filePath);
    return file.writeAsString(content);
  }
}
