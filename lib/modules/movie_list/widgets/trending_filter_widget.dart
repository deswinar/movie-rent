import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrendingFilterWidget extends StatelessWidget {
  final String selected;
  final void Function(String) onChanged;

  const TrendingFilterWidget({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['day', 'week'].map((value) {
        final isSelected = selected == value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ChoiceChip(
            label: Text(value.capitalizeFirst!),
            selected: isSelected,
            onSelected: (_) => onChanged(value),
          ),
        );
      }).toList(),
    );
  }
}
