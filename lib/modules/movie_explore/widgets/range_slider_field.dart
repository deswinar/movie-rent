import 'package:flutter/material.dart';

class RangeSliderField extends StatelessWidget {
  final String label;
  final double min;
  final double max;
  final double start;
  final double end;
  final void Function(double, double) onChanged;

  const RangeSliderField({
    super.key, 
    required this.label,
    required this.min,
    required this.max,
    required this.start,
    required this.end,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${start.toStringAsFixed(1)} - ${end.toStringAsFixed(1)}', style: Theme.of(context).textTheme.labelLarge),
        RangeSlider(
          values: RangeValues(start, end),
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          labels: RangeLabels(
            start.toStringAsFixed(1),
            end.toStringAsFixed(1),
          ),
          onChanged: (range) => onChanged(range.start, range.end),
        ),
      ],
    );
  }
}
