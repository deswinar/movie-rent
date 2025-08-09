import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/modules/auth/widgets/auth_text_field.dart';
import 'package:movie_rent/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final state = authController.authState.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthTextField(
                controller: emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: obscurePassword.value,
                suffixIcon: IconButton(
                  icon: Icon(obscurePassword.value ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => obscurePassword.toggle(),
                ),
              ),
              const SizedBox(height: 24),
              if (state is BaseStateLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: () {
                    authController.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: const Text("Login"),
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.register),
                child: const Text("Don't have an account? Register"),
              ),
              if (state is BaseStateError)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
            ],
          );
        }),
      ),
    );
  }
}
