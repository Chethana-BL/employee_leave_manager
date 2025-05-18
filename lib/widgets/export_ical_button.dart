import 'package:flutter/material.dart';

import '../models/absence.dart';
import '../services/ical_export_factory.dart';

class ExportAbsencesButton extends StatelessWidget {
  const ExportAbsencesButton({
    super.key,
    required this.absences,
  });

  final List<Absence> absences;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Download as iCal',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            final service = createICalExportService();
            await service.exportAbsencesToICal(absences);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Absences exported to iCal')),
              );
            }
          },
          backgroundColor: Colors.grey[200],
          child: Icon(
            Icons.download,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
