import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget that allows the user to select a date range for filtering.
class FilterDateSelector extends StatelessWidget {
  const FilterDateSelector({
    super.key,
    required this.selectedRange,
    required this.onChanged,
    required this.onClear,
  });
  final DateTimeRange? selectedRange;
  final void Function(DateTimeRange?) onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM d, yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.date_range, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Date Range'),
            const Spacer(),
            if (selectedRange != null)
              TextButton(onPressed: onClear, child: const Text('Clear')),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              initialDateRange: selectedRange,
            );
            if (picked != null) onChanged(picked);
          },
          child: Text(
            selectedRange == null
                ? 'Select Date Range'
                : '${formatter.format(selectedRange!.start)} to ${formatter.format(selectedRange!.end)}',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
