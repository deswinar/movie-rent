import 'package:flutter/material.dart';
import 'package:movie_rent/modules/movie_explore/widgets/dropdown_field.dart';

class YearFilter extends StatelessWidget {
  final int? selectedYear;
  final ValueChanged<int?> onChanged;

  const YearFilter({super.key, required this.selectedYear, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(30, (i) => currentYear - i);

    return DropdownField<int>(
      label: 'Year',
      value: selectedYear ?? currentYear,
      items: years,
      onChanged: onChanged,
    );
  }
}
