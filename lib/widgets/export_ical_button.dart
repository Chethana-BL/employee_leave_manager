import 'package:flutter/material.dart';
import '../models/absence.dart';
import '../services/ical_export_service.dart';

class ExportAbsencesButton extends StatelessWidget {
  const ExportAbsencesButton({
    super.key,
    required this.absences,
  });
  final List<Absence> absences;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.calendar_today),
      label: const Text('Export All to iCal'),
      onPressed: () async {
        final service = ICalExportService();
        await service.exportAbsencesToICal(absences);
      },
    );
  }
}
