import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/modules/movie_explore/controllers/movie_explore_controller.dart';

class ActiveFiltersWidget extends StatelessWidget {
  const ActiveFiltersWidget({
    super.key,
    required this.controller,
  });

  final MovieExploreController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipBackgroundColor = theme.chipTheme.backgroundColor ??
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2);

    return Obx(() {
      final tags = controller.activeTags;
      if (tags.isEmpty) return const SizedBox();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Filters',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: controller.clearAllTags,
                  icon: const Icon(Icons.clear_all),
                  label: const Text("Clear All"),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: chipBackgroundColor,
                  onDeleted: () => controller.removeTag(tag),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}
