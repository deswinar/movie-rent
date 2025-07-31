import 'package:get/get.dart';
import 'package:movie_rent/modules/home/bindings/home_binding.dart';
import 'package:movie_rent/modules/main_navigation/controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainNavigationController());

    HomeBinding().dependencies();
  }
}
