import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:movie_rent/modules/main_navigation/controllers/main_navigation_controller.dart';

class FakeHomeScreen extends StatelessWidget {
  const FakeHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Text('Home Screen');
}

class FakeRentedScreen extends StatelessWidget {
  const FakeRentedScreen({super.key});
  @override
  Widget build(BuildContext context) => const Text('Rented Screen');
}

class FakeExploreScreen extends StatelessWidget {
  const FakeExploreScreen({super.key});
  @override
  Widget build(BuildContext context) => const Text('Explore Screen');
}

class FakeProfileScreen extends StatelessWidget {
  const FakeProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Text('Profile Screen');
}

Widget buildTestWidget() {
  return GetMaterialApp(
    home: Builder(
      builder: (context) {
        return Scaffold(
          body: MainNavigationScreenWithFakes(),
        );
      },
    ),
  );
}

class MainNavigationScreenWithFakes extends StatelessWidget {
  const MainNavigationScreenWithFakes({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainNavigationController());

    final List<Widget> screens = const [
      FakeHomeScreen(),
      FakeRentedScreen(),
      FakeExploreScreen(),
      FakeProfileScreen(),
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
            BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Rented'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      );
    });
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
  });

  testWidgets('shows HomeScreen by default', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.text('Home Screen'), findsOneWidget);
  });

  testWidgets('navigates to Rented tab', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    debugPrint('Tapping Rented tab');
    await tester.tap(find.text('Rented'));
    await tester.pumpAndSettle();
    debugPrint('Rented tab opened');
    expect(find.text('Rented Screen'), findsOneWidget);
  });

  testWidgets('navigates to Explore tab', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    debugPrint('Tapping Explore tab');
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    debugPrint('Explore tab opened');
    expect(find.text('Explore Screen'), findsOneWidget);
  });

  testWidgets('navigates to Profile tab', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    debugPrint('Tapping Profile tab');
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    debugPrint('Profile tab opened');
    expect(find.text('Profile Screen'), findsOneWidget);
  });
}
