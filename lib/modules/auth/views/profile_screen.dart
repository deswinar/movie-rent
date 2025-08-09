import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/modules/auth/widgets/logged_out_view.dart';
import 'package:movie_rent/modules/profile/controllers/user_controller.dart';
import 'package:movie_rent/modules/profile/views/profile_detail_view.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!authController.isLoggedIn) {
        return const LoggedOutView();
      }

      final user = authController.appUser.value;

      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return ProfileDetailView(
        userRx: authController.appUser,
      );
    });
  }
}
