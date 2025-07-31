import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/modules/movie_search/controllers/movie_search_controller.dart';
import 'package:movie_rent/modules/movie_search/widgets/movie_search_bar.dart';
import 'package:movie_rent/modules/movie_search/widgets/movie_search_result.dart';

class MovieSearchScreen extends StatelessWidget {
  const MovieSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MovieSearchController>();
    final query = Get.arguments as String? ?? '';

    // Trigger search only if query exists and no search has been run yet
    if (query.isNotEmpty && controller.query.value != query) {
      controller.search(query);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: MovieSearchBar(
              initialValue: controller.query.value,
              onSearch: (query) => controller.search(query),
            ),
          ),
          Expanded(
            child: MovieSearchResult(controller: controller),
          ),
        ],
      ),
    );
  }
}
