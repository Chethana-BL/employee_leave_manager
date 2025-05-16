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
    return Center(
      child: Text('$fromIndex - $toIndex of $totalItems absences'),
    );
  }
}
