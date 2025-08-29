import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/widgets/app_empty.dart';
import 'package:movie_rent/core/widgets/app_error.dart';
import 'package:movie_rent/core/widgets/app_loader.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/modules/rent/controllers/my_rented_movie_controller.dart';
import 'package:movie_rent/modules/rent/widgets/my_rent_filter_sheet.dart';
import '../widgets/movie_rent_tile.dart';

class MyRentedMoviesScreen extends StatelessWidget {
  const MyRentedMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyRentedMoviesController>();
    final authController = Get.find<AuthController>();

    return Obx(() {
      final userId = authController.appUser.value?.uid ?? '';

      if (!authController.isLoggedIn) {
        return const Scaffold(
          body: Center(
            child: Text("You must be logged in to view your rentals."),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('My Rented Movies'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => MovieRentFilterSheet(controller: controller),
                );
              },
            )
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              controller.fetchMoreRents(userId: userId);
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.fetchInitialRents(userId: userId);
            },
            child: Obx(() {
              if (controller.isLoading && controller.rentedMovies.isEmpty) {
                return const AppLoader();
              }

              if (controller.hasError && controller.rentedMovies.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 200,
                      child: AppError(
                        message: controller.errorMessage,
                        onRetry: () => controller.fetchInitialRents(userId: userId),
                      ),
                    ),
                  ],
                );
              }

              if (controller.rentedMovies.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(
                      height: 200, // enough space for pull gesture
                      child: Center(child: AppEmpty(message: "No rented movies yet.")),
                    ),
                  ],
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.rentedMovies.length +
                    (controller.hasMore ? 1 : 0),
                itemBuilder: (_, index) {
                  if (index < controller.rentedMovies.length) {
                    final rent = controller.rentedMovies[index];
                    return MovieRentTile(rent: rent);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            }),
          ),
        ),
      );
    });
  }
}

