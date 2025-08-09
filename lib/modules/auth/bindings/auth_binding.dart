import 'package:get/get.dart';
import 'package:movie_rent/data/repositories/user_repository.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/data/repositories/auth_repository.dart';
import 'package:movie_rent/modules/profile/controllers/user_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(UserRepository());
    Get.put(
      AuthController(
        authRepository: Get.find(),
        userRepository: Get.find(),
      ),
      permanent: true,
    );
    Get.put(UserController(Get.find()));
  }
}

