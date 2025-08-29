import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/core/widgets/app_loader.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/modules/auth/widgets/auth_text_field.dart';
import 'package:movie_rent/routes/app_routes.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find();

  final _formKey = GlobalKey<FormState>();

  // Text Editing Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late FocusNode _passwordFocusNode;

  final RxBool obscurePassword = true.obs;

  // Rive
  late File _riveFile;
  late RiveWidgetController _riveWidgetController;
  late StateMachine _stateMachine;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _passwordFocusNode = FocusNode();

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        // When unfocused, open the eyes
        _stateMachine.trigger('Open Eye')?.fire();
      } else {
        // When focused and visibility off, close the eyes
        if (obscurePassword.value) {
          _stateMachine.trigger('Close Eye')?.fire();
        }
      }
    });

    _riveFile = (await File.asset('assets/animations/rive/wizcat.riv', riveFactory: Factory.rive))!;
    _riveWidgetController = RiveWidgetController(
      _riveFile,
      stateMachineSelector: StateMachineSelector.byIndex(0),
    );
    _stateMachine = _riveWidgetController.stateMachine;
    setState(() => isInitialized = true);
    ever(authController.authState, (state) {
      if (state is BaseStateError) {
        _stateMachine.trigger('Question')?.fire();
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _passwordFocusNode.dispose();
    _riveFile.dispose();
    _riveWidgetController.dispose();
    _stateMachine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const AppLoader();
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: RiveWidget(
                controller: _riveWidgetController,
                fit: Fit.contain,
                layoutScaleFactor: 1 / 3,
                hitTestBehavior: RiveHitTestBehavior.translucent,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              final state = authController.authState.value;

              final hover = _stateMachine.boolean('Hover');
              if (hover != null) {
                hover.value = state is BaseStateLoading;
              }

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      controller: emailController,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!GetUtils.isEmail(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: obscurePassword.value,
                      focusNode: _passwordFocusNode,
                      onChanged: (_) {
                        if (obscurePassword.value) {
                          _stateMachine.trigger('Close Eye')?.fire();
                        }
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword.value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          obscurePassword.toggle();
                          if (obscurePassword.value) {
                            _stateMachine.trigger('Close Eye')?.fire();
                          } else {
                            _stateMachine.trigger('Open Eye')?.fire();
                          }
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    if (state is BaseStateLoading)
                      const AppLoader()
                    else
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
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
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
