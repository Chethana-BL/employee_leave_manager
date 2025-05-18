import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/absence.dart';
import 'ical_export_service.dart';

ICalExportService createICalExportService() => ICalExportServiceMobile();

/// Implementation of [ICalExportService] for mobile platforms.
class ICalExportServiceMobile extends ICalExportService {
  @override
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

  Future<File> saveToFile(String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMddTHHmmss').format(DateTime.now());
    final filePath = '${directory.path}/absences_$timestamp.ics';
    final file = File(filePath);
    return file.writeAsString(content);
  }
}
