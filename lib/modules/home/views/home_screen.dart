import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/modules/home/controllers/home_controller.dart';
import 'package:movie_rent/modules/home/widgets/movie_category_section.dart';
import 'package:movie_rent/modules/movie_search/widgets/movie_search_bar.dart';
import 'package:movie_rent/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Movies'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          for (final category in MovieCategory.values) {
            controller.refreshCategory(category);
          }
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MovieSearchBar(
                  // readOnly: true,
                  hintText: 'Search for movies...',
                  onSearch: (query) {
                    if (query.isNotEmpty) {
                      log('Search query: $query');
                      Get.toNamed(AppRoutes.movieSearch, arguments: query);
                    }
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = MovieCategory.values[index];
                    return MovieCategorySection(category: category);
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