import 'package:get/get.dart';
import 'package:movie_rent/modules/genre/bindings/genre_binding.dart';
import 'package:movie_rent/modules/movie_explore/controllers/movie_explore_controller.dart';

class MovieExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovieExploreController(Get.find()));
    GenreBinding().dependencies();
  }
}
