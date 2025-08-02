import 'package:get/get.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/modules/auth/bindings/auth_binding.dart';
import 'package:movie_rent/modules/main_navigation/bindings/main_navigation_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();
    Get.put<MovieApiService>(MovieApiService(), permanent: true);
    MainNavigationBinding().dependencies();
  }
}