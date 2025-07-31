import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void onTabSelected(int index) {
    selectedIndex.value = index;
  }
}
