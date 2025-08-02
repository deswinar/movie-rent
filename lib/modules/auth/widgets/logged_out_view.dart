import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoggedOutView extends StatelessWidget {
  const LoggedOutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You are not logged in.", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.toNamed('/login'),
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
