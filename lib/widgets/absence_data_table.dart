import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/absence.dart';
import '../models/absence_status.dart';
import '../models/absence_type.dart';

class AbsenceDataTable extends StatelessWidget {
  const AbsenceDataTable({
    super.key,
    required this.absences,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.itemsPerPage,
  });
  final List<Absence> absences;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int itemsPerPage;

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  String _calculateDays(DateTime start, DateTime end) {
    // Ensure the end date is after the start date
    if (end.isBefore(start)) {
      return '0';
    }
    // Calculate the difference in days
    return "${end.difference(start).inDays + 1} ${end.difference(start).inDays == 0 ? 'day' : 'days'}";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Employee')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Start')),
            DataColumn(label: Text('End')),
            DataColumn(label: Text('Days')),
            DataColumn(label: Text('Note')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Admitter Note')),
          ],
          rows: absences.map((absence) {
            return DataRow(
              cells: [
                DataCell(Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(absence.member.image),
                      radius: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(absence.member.name),
                  ],
                )),
                DataCell(Text(absence.type.label)),
                DataCell(Text(_formatDate(absence.startDate))),
                DataCell(Text(_formatDate(absence.endDate))),
                DataCell(
                    Text(_calculateDays(absence.startDate, absence.endDate))),
                DataCell(Text(absence.memberNote?.isNotEmpty == true
                    ? absence.memberNote!
                    : '-')),
                DataCell(Text(absence.status.label)),
                DataCell(Text(absence.admitterNote?.isNotEmpty == true
                    ? absence.admitterNote!
                    : '-')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
