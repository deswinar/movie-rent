import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/responses/credits_response.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/modules/movie_detail/widgets/backdrop_image.dart';
import 'package:movie_rent/modules/movie_detail/widgets/credits_section.dart';
import 'package:movie_rent/modules/movie_detail/widgets/info_chips.dart';
import 'package:movie_rent/modules/movie_detail/widgets/overview_section.dart';
import 'package:movie_rent/modules/movie_detail/widgets/rating_section.dart';
import 'package:movie_rent/modules/movie_detail/widgets/title_section.dart';
import 'package:movie_rent/routes/app_routes.dart';

import '../controllers/movie_detail_controller.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieId = Get.arguments as int;

    final MovieDetailController controller = Get.find();

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
                            state.message ?? 'Unknown error',
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final authController = Get.find<AuthController>();
          final isLoggedIn = authController.isLoggedIn;
          final alreadyRented = controller.isAlreadyRented.value;

          return SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: alreadyRented
                  ? null // disable if already rented
                  : () {
                      if (isLoggedIn) {
                        Get.toNamed(AppRoutes.rentMovie, arguments: controller.movie);
                      } else {
                        Get.snackbar("Login required", "Please login to rent a movie.");
                        Get.toNamed(AppRoutes.login);
                      }
                    },
              icon: Icon(
                alreadyRented
                    ? Icons.check_circle
                    : isLoggedIn
                        ? Icons.shopping_cart
                        : Icons.login,
              ),
              label: Text(
                alreadyRented
                    ? "Already Rented"
                    : isLoggedIn
                        ? "Rent this movie"
                        : "Login to rent",
              ),
            ),
          );
        }),
      ),
    );
  }
}
