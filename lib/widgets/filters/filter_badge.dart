import 'package:flutter/material.dart';

/// A widget that displays a badge with the number of active filters.
class FilterBadge extends StatelessWidget {
  const FilterBadge({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: CircleAvatar(
        radius: 10,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          '$count',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
