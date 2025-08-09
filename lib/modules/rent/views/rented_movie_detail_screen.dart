import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:movie_rent/core/helpers/image_helper.dart';
import 'package:movie_rent/data/models/movie_rent.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/modules/movie_detail/controllers/movie_detail_controller.dart';
import 'package:movie_rent/routes/app_routes.dart';

class RentedMovieDetailScreen extends StatelessWidget {
  const RentedMovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rent = Get.arguments as MovieRent;
    final movieDetailController = Get.find<MovieDetailController>();

    // Immediately fetch movie detail on screen load
    movieDetailController.fetchMovieDetail(id: rent.movieId).then((_) {
      if (movieDetailController.movie != null) {
        movieDetailController.checkIfAlreadyRented(movieId: movieDetailController.movie!.id);
      }
    });
    
    final rentDate = rent.rentDate.toDate();
    final formattedRentDate = DateFormat('dd MMM yyyy').format(rentDate);

    final imageUrl = ImageHelper.getUrl(rent.posterUrl, size: 'w780');

    return Scaffold(
      appBar: AppBar(title: Text(rent.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Movie Poster (optional)
          if (rent.posterUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: imageUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),

          const SizedBox(height: 16),

          Text(
            rent.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),

          Text("Status: ${rent.status}"),
          Text("Rented on: $formattedRentDate"),
          Text("Due Date: ${DateFormat('dd MMM yyyy').format(rent.expireAt.toDate())}"),

          const SizedBox(height: 16),

          if (rent.title.isNotEmpty)
            Text(
              rent.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

          const SizedBox(height: 24),

          if (rent.status == "expired") ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Your rental has expired. Rent it again to continue watching.",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
      bottomNavigationBar: Obx(() {
        final authController = Get.find<AuthController>();
        final isLoggedIn = authController.isLoggedIn;
        final alreadyRented = movieDetailController.isAlreadyRented.value;

        if (rent.status != "expired") {
          return const SizedBox.shrink(); // hide button if not expired
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: alreadyRented
                  ? null
                  : () {
                      if (isLoggedIn) {
                        Get.toNamed(AppRoutes.rentMovie, arguments: movieDetailController.movie);
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
                        ? "Rent Again"
                        : "Login to rent",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}
