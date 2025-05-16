import 'package:flutter/material.dart';

class PageControls extends StatelessWidget {
  const PageControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onNextPage,
    this.onPreviousPage,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback? onNextPage;
  final VoidCallback? onPreviousPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage > 0 ? onPreviousPage : null,
          icon: const Icon(Icons.arrow_back),
        ),
        Text(
          'Page ${currentPage + 1} of $totalPages',
        ),
        IconButton(
          onPressed: currentPage < totalPages - 1 ? onNextPage : null,
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
