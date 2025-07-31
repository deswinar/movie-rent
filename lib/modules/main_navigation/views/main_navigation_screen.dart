import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/modules/home/views/home_screen.dart';
import 'package:movie_rent/modules/main_navigation/controllers/main_navigation_controller.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainNavigationController());

    final List<Widget> screens = const [
      HomeScreen(),
      Placeholder(), // TODO: Replace with FavoritesScreen()
      Placeholder(), // TODO: Replace with ProfileScreen()
    ];

    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onTabSelected,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      );
    });
  }
}
