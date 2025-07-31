import 'package:get/get.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/modules/movie_search/controllers/movie_search_controller.dart';

class MovieSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>MovieApiService());
    Get.lazyPut(() => MovieSearchController(Get.find()));

  }
}
