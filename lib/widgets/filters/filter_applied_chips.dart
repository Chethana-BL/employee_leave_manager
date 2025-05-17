import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/absence_status.dart';
import '../../models/absence_type.dart';
import '../../models/filters/absence_filter_model.dart';

/// A widget that displays selected filters as chips.
/// It allows the user to clear individual filters by tapping on the chip.
/// The widget takes a [filters] object and a callback function [onFilterChanged]
/// to update the filter state when a chip is deleted.
class FilterAppliedChips extends StatelessWidget {
  const FilterAppliedChips({
    super.key,
    required this.filters,
    required this.onFilterChanged,
  });
  final AbsenceFilterModel filters;
  final void Function(AbsenceFilterModel updatedFilters) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    if (filters.type != null) {
      chips.add(FilterChip(
        label: Text(filters.type!.label),
        onDeleted: () => _clearFilterFor(type: true),
        onSelected: (_) {},
      ));
    }

    if (filters.status != null) {
      chips.add(FilterChip(
        label: Text(filters.status!.label),
        onDeleted: () => _clearFilterFor(status: true),
        onSelected: (_) {},
      ));
    }

    if (filters.employee != null) {
      chips.add(FilterChip(
        label: Text(filters.employee!.name),
        onDeleted: () => _clearFilterFor(employee: true),
        onSelected: (_) {},
      ));
    }

    if (filters.dateRange != null) {
      final formatter = DateFormat('MMM d, yyyy');
      final start = formatter.format(filters.dateRange!.start);
      final end = formatter.format(filters.dateRange!.end);

      chips.add(FilterChip(
        label: Text('$start to $end'),
        onDeleted: () => _clearFilterFor(date: true),
        onSelected: (_) {},
      ));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }

  void _clearFilterFor({
    bool type = false,
    bool status = false,
    bool employee = false,
    bool date = false,
  }) {
    final updated = filters.copy()
      ..type = type ? null : filters.type
      ..status = status ? null : filters.status
      ..employee = employee ? null : filters.employee
      ..dateRange = date ? null : filters.dateRange;

    onFilterChanged(updated);
  }
}
