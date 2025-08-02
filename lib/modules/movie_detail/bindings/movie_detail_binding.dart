import 'package:get/get.dart';
import 'package:movie_rent/modules/movie_detail/controllers/movie_detail_controller.dart';

class MovieDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovieDetailController(Get.find()));
  }
}
