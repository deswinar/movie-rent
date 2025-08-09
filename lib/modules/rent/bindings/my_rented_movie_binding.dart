import 'package:get/get.dart';
import 'package:movie_rent/data/repositories/rent_repository.dart';
import 'package:movie_rent/modules/rent/controllers/my_rented_movie_controller.dart';

class MyRentedMovieBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RentRepository());
    Get.lazyPut(() => MyRentedMoviesController(rentRepository: Get.find()));
  }
}
