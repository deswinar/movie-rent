import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/modules/movie_list/widgets/movie_item_card.dart';
import 'package:movie_rent/modules/movie_explore/controllers/movie_explore_controller.dart';

class MovieExploreResult extends StatelessWidget {
  final MovieExploreController controller;

  const MovieExploreResult({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.exploreState.value;

      if (state is BaseStateLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is BaseStateError) {
        return Center(child: Text((state as BaseStateError).message));
      }

      if (state is BaseStateSuccess<List<MovieModel>>) {
        final movies = state.data;

        if (movies.isEmpty) {
          return const Center(child: Text("No movies found."));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              controller.fetchMore();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: movies.length + (controller.canLoadMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == movies.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final movie = movies[index];
              return MovieItemCard(movie: movie);
            },
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}
