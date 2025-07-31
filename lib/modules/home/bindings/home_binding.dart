import 'package:get/get.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/modules/home/controllers/home_controller.dart';
import 'package:movie_rent/modules/movie_search/controllers/movie_search_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>MovieApiService());
    Get.lazyPut(() => HomeController(movieApiService: Get.find()));
    Get.lazyPut(() => MovieSearchController(Get.find()));
  }
}
