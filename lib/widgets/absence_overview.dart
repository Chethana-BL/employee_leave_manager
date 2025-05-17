import 'package:flutter/material.dart';

/// A widget that displays the range of absences currently displayed
class AbsenceOverview extends StatelessWidget {
  const AbsenceOverview({
    super.key,
    required this.fromIndex,
    required this.toIndex,
    required this.totalItems,
  });

  final int fromIndex;
  final int toIndex;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.analytics_outlined,
                color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Text(
              'Absences listed: $fromIndex–$toIndex of $totalItems',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
