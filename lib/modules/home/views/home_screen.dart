import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/modules/home/controllers/home_controller.dart';
import 'package:movie_rent/modules/home/widgets/movie_category_section.dart';
import 'package:movie_rent/modules/home/widgets/popular_hero_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          for (final category in MovieCategory.values) {
            controller.refreshCategory(category);
          }
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = MovieCategory.values[index];
                    if (category == MovieCategory.popular) {
                      return PopularHeroSection(category: category);
                    } else {
                      return MovieCategorySection(category: category);
                    }
                    // return MovieCategorySection(category: category);
                  },
                  childCount: MovieCategory.values.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}