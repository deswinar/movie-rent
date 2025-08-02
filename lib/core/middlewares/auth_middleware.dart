import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // Redirect to login if not logged in
    if (!authController.isLoggedIn && route == '/profile') {
      return RouteSettings(name: '/login');
    }

    // Redirect to profile if already logged in
    if (authController.isLoggedIn && (route == '/login' || route == '/register')) {
      return RouteSettings(name: '/profile');
    }

    return null; // allow navigation
  }
}
