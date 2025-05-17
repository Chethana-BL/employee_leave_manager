import 'package:flutter/material.dart';

class FilterDropdown<T> extends StatelessWidget {
  const FilterDropdown({
    super.key,
    required this.title,
    required this.icon,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.onClear,
  });
  final String title;
  final IconData icon;
  final T? selectedValue;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            if (selectedValue != null)
              TextButton(onPressed: onClear, child: const Text('Clear')),
          ],
        ),
        DropdownButton<T>(
          isExpanded: true,
          value: selectedValue,
          items: items,
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
