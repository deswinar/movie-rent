import 'package:flutter/material.dart';

class OverviewSection extends StatelessWidget {
  final String overview;
  const OverviewSection({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          overview,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
