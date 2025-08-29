import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/bindings/initial_binding.dart';
import 'package:movie_rent/core/services/firebase_service.dart';
import 'package:movie_rent/core/theme/app_theme.dart';
import 'package:movie_rent/core/transitions/fade_scale_transition.dart';
import 'package:movie_rent/routes/app_pages.dart';
import 'package:movie_rent/routes/app_routes.dart';
import 'package:rive/rive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RiveNative.init();

  await dotenv.load(fileName: ".env");
  await Get.putAsync(() => FirebaseService().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Rent',
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      customTransition: FadeScaleTransition(),
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}