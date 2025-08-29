import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/core/widgets/app_loader.dart';
import 'package:movie_rent/modules/home/controllers/home_controller.dart';
import 'package:movie_rent/modules/home/widgets/movie_card.dart';
import 'package:movie_rent/routes/app_routes.dart';

class MovieCategorySection extends StatelessWidget {
  final MovieCategory category;

  const MovieCategorySection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final state = controller.getCategoryState(category);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.movieList,
                      arguments: category,
                    );
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
          ),

          // Add timeWindow toggle for trending
          if (category == MovieCategory.trending)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                final selected = controller.trendingTimeWindow.value;
                return Row(
                  children: ['day', 'week'].map((time) {
                    final isSelected = selected == time;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(time.capitalizeFirst!),
                        selected: isSelected,
                        onSelected: (_) {
                          controller.setTrendingTimeWindow(time);
                        },
                      ),
                    );
                  }).toList(),
                );
              }),
            ),

          const SizedBox(height: 8),

          // Movie list
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: switch (state) {
              BaseStateLoading _ =>
                const AppLoader(),
              BaseStateError _ =>
                Center(child: Text(controller.errorMessage(category))),
              BaseStateSuccess<List> success => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: success.data.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    return MovieCard(movie: success.data[index]);
                  },
                ),
              _ => const SizedBox(),
            },
          ),

          const SizedBox(height: 16),
        ],
      );
    });
  }
}