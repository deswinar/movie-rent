import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeField extends StatelessWidget {
  final String label;
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime? start, DateTime? end) onChanged;

  const DateRangeField({
    super.key,
    required this.label,
    this.startDate,
    this.endDate,
    required this.onChanged,
  });

  String _format(DateTime? date) {
    if (date == null) return 'Select';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final initialStart = startDate ?? DateTime(now.year - 5);
    final initialEnd = endDate ?? now;

    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) {
      onChanged(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDateRange(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          children: [
            Expanded(child: Text('From: ${_format(startDate)}')),
            const SizedBox(width: 12),
            Expanded(child: Text('To: ${_format(endDate)}')),
            const Icon(Icons.date_range),
          ],
        ),
      ),
    );
  }
}
