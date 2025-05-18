import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

import '../models/absence.dart';
import 'ical_export_service.dart';

ICalExportService createICalExportService() => ICalExportServiceWeb();

/// Implementation of [ICalExportService] for web platforms.
class ICalExportServiceWeb extends ICalExportService {
  @override
  Future<void> exportAbsencesToICal(List<Absence> absences) async {
    final icsContent = generateICalContent(absences);
    final bytes = utf8.encode(icsContent);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final timestamp = DateFormat('yyyyMMddTHHmmss').format(DateTime.now());
    final filePath = '/absences_$timestamp.ics';

    html.AnchorElement(href: url)
      ..setAttribute('download', filePath)
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
