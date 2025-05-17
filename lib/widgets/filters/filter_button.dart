import 'package:flutter/material.dart';

import 'filter_badge.dart';

/// A button that displays a filter icon and the number of active filters.
class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.activeFilterCount,
    required this.onPressed,
  });
  final int activeFilterCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.filter_alt_outlined),
          const SizedBox(width: 4),
          const Text('Filter'),
          FilterBadge(count: activeFilterCount),
        ],
      ),
    );
  }
}
