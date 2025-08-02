import 'package:get/get.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/modules/genre/controllers/genre_controller.dart';

class GenreBinding extends Bindings {
  GenreBinding();

  @override
  void dependencies() {
    Get.lazyPut(() => GenreController(Get.find<MovieApiService>()));
  }
}
