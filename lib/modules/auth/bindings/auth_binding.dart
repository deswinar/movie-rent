import 'package:get/get.dart';
import 'package:movie_rent/data/repositories/user_repository.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/data/repositories/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => UserRepository());
    Get.lazyPut(() => AuthController(authRepository: Get.find(), userRepository: Get.find()));
  }
}
