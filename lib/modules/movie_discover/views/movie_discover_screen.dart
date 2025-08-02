import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/modules/home/widgets/movie_list_tile.dart';
import 'package:movie_rent/modules/movie_discover/controllers/movie_discover_controller.dart';
import 'package:movie_rent/modules/movie_explore/widgets/filter_panel.dart';

class MovieDiscoverScreen extends StatelessWidget {
  const MovieDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MovieDiscoverController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.discover(), // Re-run with current filter
          ),
        ],
      ),
      body: Column(
        children: [
          const FilterPanel(),
          Expanded(
            child: Obx(() {
              final state = controller.discoverState.value;
              if (state is BaseStateLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BaseStateError) {
                return Center(child: Text((state as BaseStateError).message));
              } else if (state is BaseStateSuccess<List<MovieModel>>) {
                final results = state.data;
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final movie = results[index];
                    return MovieListTile(movie: movie);
                  },
                );
              } else {
                return const SizedBox();
              }
            }),
          ),
        ],
      ),
    );
  }
}
