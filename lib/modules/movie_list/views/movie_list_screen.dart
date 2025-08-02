import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/modules/movie_list/controllers/movie_list_controller.dart';
import 'package:movie_rent/modules/movie_list/widgets/movie_list_view.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/modules/movie_list/widgets/trending_filter_widget.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MovieListController>();
    controller.category = Get.arguments as MovieCategory;
    controller.fetchInitialMovies();

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.category.label),
        bottom: controller.category == MovieCategory.trending
            ? PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Obx(() => TrendingFilterWidget(
                      selected: controller.trendingTimeWindow,
                      onChanged: (val) {
                        controller.trendingTimeWindow = val;
                        controller.fetchInitialMovies();
                      },
                    )),
              )
            : null,
      ),
      body: Obx(() {
        final state = controller.movieState.value;

        if (state is BaseStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BaseStateError) {
          return Center(child: Text((state as BaseStateError).message));
        } else if (state is BaseStateSuccess<List<MovieModel>>) {
          final movies = state.data;

          if (movies.isEmpty) {
            return const Center(child: Text("No movies available"));
          }

          return MovieListView(
            movies: movies,
            onScrollEnd: controller.fetchMoreMovies,
            canLoadMore: controller.canLoadMore,
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}
