import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/core/widgets/app_loader.dart';
import 'package:movie_rent/modules/home/controllers/home_controller.dart';
import 'package:movie_rent/modules/home/widgets/movie_hero_card.dart';
import 'package:movie_rent/routes/app_routes.dart';

class PopularHeroSection extends StatelessWidget {
  final MovieCategory category;

  const PopularHeroSection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final pageController = PageController(viewportFraction: 1);

    return Obx(() {
      final state = controller.getCategoryState(category);

      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: Stack(
          children: [
            // Carousel content
            switch (state) {
              BaseStateLoading _ => const AppLoader(),
              BaseStateError _ => Center(child: Text(controller.errorMessage(category))),
              BaseStateSuccess<List> success => PageView.builder(
                  controller: pageController,
                  itemCount: success.data.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (pageController.position.haveDimensions) {
                          value = pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
                        }
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: MovieHeroCard(movie: success.data[index]),
                      ),
                    );
                  },
                ),
              _ => const SizedBox(),
            },
            // Overlay header
            Positioned(
              left: 16,
              right: 16,
              top: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              blurRadius: 8,
                              color: Colors.black87,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.movieList, arguments: category);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black45,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}