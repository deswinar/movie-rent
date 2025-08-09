import 'package:get/get.dart';
import 'package:movie_rent/modules/home/bindings/home_binding.dart';
import 'package:movie_rent/modules/main_navigation/controllers/main_navigation_controller.dart';
import 'package:movie_rent/modules/movie_explore/bindings/movie_explore_binding.dart';
import 'package:movie_rent/modules/rent/bindings/my_rented_movie_binding.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainNavigationController());

    HomeBinding().dependencies();
    MyRentedMovieBinding().dependencies();
    MovieExploreBinding().dependencies();
  }
}
