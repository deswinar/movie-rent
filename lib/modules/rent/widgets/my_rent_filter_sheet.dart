import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/modules/rent/controllers/my_rented_movie_controller.dart';

class MovieRentFilterSheet extends StatelessWidget {
  final MyRentedMoviesController controller;

  const MovieRentFilterSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final statuses = ['all', 'active', 'expired', 'returned'];
    final sortFields = {
      'Rent Date': 'rentDate',
      'Expire Date': 'expireAt',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Filter & Sort', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Status Filter
          DropdownButtonFormField<String>(
            value: controller.selectedStatus.value.isEmpty ? 'all' : controller.selectedStatus.value,
            decoration: const InputDecoration(labelText: 'Status'),
            items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s.capitalizeFirst!))).toList(),
            onChanged: (value) {
              controller.selectedStatus.value = value == 'all' ? '' : value!;
            },
          ),

          const SizedBox(height: 16),

          // Sort Field
          DropdownButtonFormField<String>(
            value: controller.sortBy.value,
            decoration: const InputDecoration(labelText: 'Sort by'),
            items: sortFields.entries
                .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                .toList(),
            onChanged: (value) {
              if (value != null) controller.sortBy.value = value;
            },
          ),

          const SizedBox(height: 16),

          // Descending Toggle
          Obx(() => SwitchListTile(
            title: const Text('Descending Order'),
            value: controller.descending.value,
            onChanged: (val) => controller.descending.value = val,
          )),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              controller.applyUserFilters(
                status: controller.selectedStatus.value,
                sortField: controller.sortBy.value,
                isDescending: controller.descending.value,
              );
              Get.back();
            },
            child: const Text('Apply'),
          )
        ],
      ),
    );
  }
}
