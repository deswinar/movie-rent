import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/responses/credits_response.dart';
import 'package:movie_rent/modules/movie_detail/widgets/backdrop_image.dart';
import 'package:movie_rent/modules/movie_detail/widgets/credits_section.dart';
import 'package:movie_rent/modules/movie_detail/widgets/info_chips.dart';
import 'package:movie_rent/modules/movie_detail/widgets/overview_section.dart';
import 'package:movie_rent/modules/movie_detail/widgets/rating_section.dart';
import 'package:movie_rent/modules/movie_detail/widgets/title_section.dart';

import '../controllers/movie_detail_controller.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieId = Get.arguments as int;

    final controller = Get.put(
      MovieDetailController(Get.find()),
    );

    controller.fetchMovieDetail(id: movieId);
    controller.fetchMovieCredits(id: movieId);

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Detail')),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.hasError) {
          return Center(child: Text(controller.errorMessage));
        } else if (controller.movie != null) {
          final movie = controller.movie!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackdropImage(movie: movie),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleSection(movie: movie),
                      const SizedBox(height: 12),
                      RatingSection(movie: movie),
                      const SizedBox(height: 12),
                      InfoChips(movie: movie),
                      const SizedBox(height: 20),
                      OverviewSection(overview: movie.overview),
                      const SizedBox(height: 20),
                      // Credits Section
                      Obx(() {
                        final state = controller.creditsState.value;
                        if (state is BaseStateLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is BaseStateError) {
                          return Text(
                            (state as BaseStateError).message,
                            style: const TextStyle(color: Colors.red),
                          );
                        } else if (state is BaseStateSuccess<CreditsResponse>) {
                          return CreditsSection(
                            cast: controller.cast,
                            crew: controller.crew,
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }
}
