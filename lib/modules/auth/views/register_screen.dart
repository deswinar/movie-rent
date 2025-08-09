import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/modules/auth/widgets/auth_text_field.dart';
import 'package:movie_rent/routes/app_routes.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
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
                    final password = passwordController.text.trim();

                    final passwordValid = _validatePassword(password);
                    if (!passwordValid) {
                      Get.snackbar(
                        "Invalid Password",
                        "Password must be at least 8 characters, include a number, a letter, and one uppercase letter.",
                        backgroundColor: Colors.red.shade400,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    authController.register(
                      emailController.text.trim(),
                      password,
                    );
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: const Text("Register"),
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.login),
                child: const Text("Already have an account? Login"),
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

  bool _validatePassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    final hasNumber = password.contains(RegExp(r'\d'));

    return hasMinLength && hasUppercase && hasLetter && hasNumber;
  }
}
