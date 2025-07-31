import 'package:get/get.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/modules/movie_list/controllers/movie_list_controller.dart';

class MovieListBinding extends Bindings {
  MovieListBinding();

  @override
  void dependencies() {
    Get.lazyPut(()=>MovieApiService());
    Get.lazyPut(() => MovieListController(
          movieApiService: Get.find<MovieApiService>(),
        ));
  }
}
