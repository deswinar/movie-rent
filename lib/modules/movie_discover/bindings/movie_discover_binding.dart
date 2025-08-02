import 'package:get/get.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/modules/movie_discover/controllers/movie_discover_controller.dart';
class MovieDiscoverBinding extends Bindings {
  MovieDiscoverBinding();

  @override
  void dependencies() {
    Get.lazyPut(() => MovieDiscoverController(Get.find<MovieApiService>()));
  }
}
