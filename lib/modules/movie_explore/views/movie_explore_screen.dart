import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/modules/movie_explore/widgets/active_filters_widget.dart';
import 'package:movie_rent/modules/movie_explore/widgets/filter_panel.dart';
import 'package:movie_rent/modules/movie_explore/controllers/movie_explore_controller.dart';
import 'package:movie_rent/modules/movie_explore/widgets/movie_explore_result.dart';

class MovieExploreScreen extends StatelessWidget {
  const MovieExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MovieExploreController>();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onSubmitted: controller.search,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Advanced Filter',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const FilterPanel(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Active filters
          ActiveFiltersWidget(controller: controller),
          Expanded(
            child: MovieExploreResult(controller: controller),
          ),
        ],
      ),
    );
  }
}
