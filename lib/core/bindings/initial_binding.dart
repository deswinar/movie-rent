import 'package:get/get.dart';
import 'package:movie_rent/modules/main_navigation/bindings/main_navigation_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    MainNavigationBinding().dependencies();
  }
}