import 'package:flutter/material.dart';

import '../models/absence_status.dart';
import '../models/absence_type.dart';
import '../models/member.dart';

class AbsenceFilter extends StatelessWidget {
  const AbsenceFilter({
    super.key,
    required this.selectedType,
    required this.selectedStatus,
    required this.selectedDateRange,
    required this.selectedEmployee,
    required this.allMembers,
    required this.onTypeChanged,
    required this.onStatusChanged,
    required this.onDateRangeChanged,
    required this.onEmployeeChanged,
    required this.onClearFilters,
  });
  final AbsenceType? selectedType;
  final AbsenceStatus? selectedStatus;
  final DateTimeRange? selectedDateRange;
  final Member? selectedEmployee;
  final List<Member> allMembers;

  final Function(AbsenceType?) onTypeChanged;
  final Function(AbsenceStatus?) onStatusChanged;
  final Function(DateTimeRange?) onDateRangeChanged;
  final Function(Member?) onEmployeeChanged;
  final Function() onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        DropdownButton<AbsenceType>(
            value: selectedType,
            hint: const Text('Type'),
            onChanged: onTypeChanged,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('All'),
              ),
              ...AbsenceType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                );
              }),
            ]),
        DropdownButton<AbsenceStatus>(
            value: selectedStatus,
            hint: const Text('Status'),
            onChanged: onStatusChanged,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('All'),
              ),
              ...AbsenceStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.label),
                );
              }),
            ]),
        DropdownButton<Member>(
          value: selectedEmployee,
          hint: const Text('Employee'),
          onChanged: onEmployeeChanged,
          items: allMembers.map((member) {
            return DropdownMenuItem(
              value: member,
              child: Text(member.name),
            );
          }).toList(),
        ),
        OutlinedButton(
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              initialDateRange: selectedDateRange,
            );
            onDateRangeChanged(picked);
          },
          child: const Text('Select Date Range'),
        ),
        IconButton(
          onPressed: onClearFilters,
          tooltip: 'Clear filters',
          icon: const Icon(Icons.clear),
        ),
      ],
    );
  }
}
