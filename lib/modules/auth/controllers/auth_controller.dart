import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/app_user_model.dart';
import 'package:movie_rent/data/repositories/auth_repository.dart';
import 'package:movie_rent/data/repositories/user_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthController({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository;

  final Rx<BaseState<void>> authState = BaseStateInitial<void>().obs;
  final Rxn<User> firebaseUser = Rxn<User>();
  final Rxn<AppUser> appUser = Rxn<AppUser>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_authRepository.authStateChanges());

    ever(firebaseUser, (user) async {
      if (user != null) {
        appUser.value = await _userRepository.getUser(user.uid);
      } else {
        appUser.value = null;
      }
    });
  }

  Future<void> register(String email, String password) async {
    authState.value = BaseStateLoading();

    try {
      final user = await _authRepository.register(email: email, password: password);

      final newUser = AppUser(
        uid: user?.uid ?? '',
        email: user?.email ?? '',
        name: null,
        avatarUrl: null,
        role: 'user',
        createdAt: DateTime.now(),
      );

      await _userRepository.createUser(newUser);

      authState.value = BaseStateSuccess(null);
    } on FirebaseAuthException catch (e) {
      authState.value = BaseStateError(e.message ?? 'Registration failed');
    }
  }

  Future<void> login(String email, String password) async {
    authState.value = BaseStateLoading();

    try {
      final user = await _authRepository.signIn(email: email, password: password);

      if (user != null) {
        final userData = await _userRepository.getUser(user.uid);
        appUser.value = userData;
      }

      authState.value = BaseStateSuccess(null);
    } on FirebaseAuthException catch (e) {
      authState.value = BaseStateError(e.message ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    await _authRepository.signOut();
  }

  bool get isLoggedIn => firebaseUser.value != null;
}