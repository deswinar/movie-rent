import 'package:get/get.dart';
import 'package:movie_rent/data/repositories/rent_repository.dart';
import 'package:movie_rent/modules/rent/controllers/rent_controller.dart';

class RentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RentRepository());
    Get.lazyPut(() => RentController(rentRepository: Get.find()));
  }
}
