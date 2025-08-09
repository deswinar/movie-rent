import 'package:get/get.dart';
import 'package:movie_rent/data/repositories/rent_repository.dart';
import 'package:movie_rent/modules/movie_detail/controllers/movie_detail_controller.dart';
import 'package:movie_rent/modules/rent/controllers/my_rented_movie_controller.dart';

class RentedMovieDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RentRepository(firestore: Get.find()));

    // Controllers
    Get.lazyPut(() => MovieDetailController(movieApiService: Get.find(), rentRepository: Get.find()));
    Get.lazyPut(() => MyRentedMoviesController(rentRepository: Get.find()));
  }
}
