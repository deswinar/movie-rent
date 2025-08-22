import 'package:get/get.dart';
import 'package:movie_rent/core/middlewares/auth_middleware.dart';
import 'package:movie_rent/modules/auth/views/login_screen.dart';
import 'package:movie_rent/modules/auth/views/profile_screen.dart';
import 'package:movie_rent/modules/auth/views/register_screen.dart';
import 'package:movie_rent/modules/main_navigation/bindings/main_navigation_binding.dart';
import 'package:movie_rent/modules/main_navigation/views/main_navigation_screen.dart';
import 'package:movie_rent/modules/movie_detail/bindings/movie_detail_binding.dart';
import 'package:movie_rent/modules/movie_detail/views/movie_detail_screen.dart';
import 'package:movie_rent/modules/movie_list/bindings/movie_list_binding.dart';
import 'package:movie_rent/modules/movie_list/views/movie_list_screen.dart';
import 'package:movie_rent/modules/movie_explore/bindings/movie_explore_binding.dart';
import 'package:movie_rent/modules/movie_explore/views/movie_explore_screen.dart';
import 'package:movie_rent/modules/rent/bindings/rent_binding.dart';
import 'package:movie_rent/modules/rent/bindings/rented_movie_detail_binding.dart';
import 'package:movie_rent/modules/rent/views/rent_movie_screen.dart';
import 'package:movie_rent/modules/rent/views/rented_movie_detail_screen.dart';
import 'package:movie_rent/modules/splash/views/splash_screen.dart';
import 'package:movie_rent/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
      middlewares: [AuthMiddleware()],
    ),
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
      name: AppRoutes.movieExplore,
      page: () => const MovieExploreScreen(),
      binding: MovieExploreBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.movieDiscover,
    //   page: () => const MovieDiscoverScreen(),
    //   binding: MovieDiscoverBinding(),
    // ),
    GetPage(
      name: AppRoutes.movieDetail,
      page: () => const MovieDetailScreen(),
      binding: MovieDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.rentMovie,
      page: () => const RentMovieScreen(),
      binding: RentBinding(),
    ),
    // Rent Movie Detail
    GetPage(
      name: AppRoutes.rentMovieDetail,
      page: () => const RentedMovieDetailScreen(),
      binding: RentedMovieDetailBinding(),
    ),
  ];
}
