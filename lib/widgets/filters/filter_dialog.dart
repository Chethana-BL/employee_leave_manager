import 'package:flutter/material.dart';

import '../../models/absence_status.dart';
import '../../models/absence_type.dart';
import '../../models/filters/absence_filter_model.dart';
import '../../models/member.dart';
import 'filter_badge.dart';
import 'filter_date_selector.dart';
import 'filter_dropdown.dart';

/// A dialog that allows the user to filter the absence list.
/// It contains dropdowns for leave type, status, employee, and a date range selector.
class FilterDialog extends StatefulWidget {
  const FilterDialog({
    super.key,
    required this.initialFilters,
    required this.onApply,
    required this.onClear,
    required this.allMembers,
  });

  final AbsenceFilterModel initialFilters;
  final Function(AbsenceFilterModel) onApply;

  final List<Member> allMembers;
  final VoidCallback onClear;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late AbsenceFilterModel _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters.copy();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                FilterBadge(count: _filters.activeCount),
              ],
            ),
            const SizedBox(height: 16),
            FilterDropdown<AbsenceType>(
              title: 'Leave Type',
              icon: Icons.category,
              selectedValue: _filters.type,
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...AbsenceType.values.map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.label),
                  ),
                ),
              ],
              onChanged: (val) => setState(() => _filters.type = val),
              onClear: () => setState(() => _filters.type = null),
            ),
            FilterDropdown<AbsenceStatus>(
              title: 'Status',
              icon: Icons.info_outline,
              selectedValue: _filters.status,
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...AbsenceStatus.values.map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(status.label),
                  ),
                ),
              ],
              onChanged: (val) => setState(() => _filters.status = val),
              onClear: () => setState(() => _filters.status = null),
            ),
            FilterDropdown<Member>(
              title: 'Employee',
              icon: Icons.person,
              selectedValue: _filters.employee,
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...widget.allMembers.map(
                  (member) => DropdownMenuItem(
                    value: member,
                    child: Text(member.name),
                  ),
                ),
              ],
              onChanged: (val) => setState(() => _filters.employee = val),
              onClear: () => setState(() => _filters.employee = null),
            ),
            FilterDateSelector(
              selectedRange: _filters.dateRange,
              onChanged: (val) => setState(() => _filters.dateRange = val),
              onClear: () => setState(() => _filters.dateRange = null),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: widget.onClear, child: const Text('Clear All')),
                ElevatedButton(
                  onPressed: () {
                    widget.onApply(_filters);
                  },
                  child: const Text('Apply'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
