import 'package:get/get.dart';
import 'package:movie_rent/modules/main_navigation/bindings/main_navigation_binding.dart';
import 'package:movie_rent/modules/main_navigation/views/main_navigation_screen.dart';
import 'package:movie_rent/modules/movie_list/bindings/movie_list_binding.dart';
import 'package:movie_rent/modules/movie_list/views/movie_list_screen.dart';
import 'package:movie_rent/modules/movie_search/bindings/movie_search_binding.dart';
import 'package:movie_rent/modules/movie_search/views/movie_search_screen.dart';
import 'package:movie_rent/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainNavigationScreen(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.movieList,
      page: () => const MovieListScreen(),
      binding: MovieListBinding(),
    ),
    GetPage(
      name: AppRoutes.movieSearch,
      page: () => const MovieSearchScreen(),
      binding: MovieSearchBinding(),
    ),
  ];
}
