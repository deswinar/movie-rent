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

  final authState = Rx<BaseState<void>>(BaseStateInitial());
  final Rxn<User> firebaseUser = Rxn<User>();
  final Rxn<AppUser> appUser = Rxn<AppUser>();

  @override
  void onInit() {
    super.onInit();

    // Bind Firebase user auth state
    firebaseUser.bindStream(_authRepository.authStateChanges());

    // Whenever Firebase user changes, load the Firestore user
    ever(firebaseUser, (User? user) async {
      if (user != null) {
        try {
          final fetchedUser = await _userRepository.getUser(user.uid);
          appUser.value = fetchedUser;
        } catch (e) {
          appUser.value = null;
        }
      } else {
        appUser.value = null;
      }
    });
  }

  /// Register a new user and save to Firestore
  Future<void> register(String email, String password) async {
    authState.value = BaseStateLoading();

    try {
      final user = await _authRepository.register(email: email, password: password);

      if (user == null) throw FirebaseAuthException(code: 'null-user', message: 'User creation failed');

      final newUser = AppUser(
        uid: user.uid,
        email: user.email ?? '',
        name: null,
        avatarUrl: null,
        role: 'user',
        createdAt: DateTime.now(),
      );

      await _userRepository.createUser(newUser);

      // Set appUser manually to avoid async race
      appUser.value = newUser;

      authState.value = BaseStateSuccess(null);

    } on FirebaseAuthException catch (e) {
      authState.value = BaseStateError(e.message ?? 'Registration failed');
    } catch (e) {
      authState.value = BaseStateError('Unexpected error: $e');
    }
  }

  /// Login and fetch user data
  Future<void> login(String email, String password) async {
    authState.value = BaseStateLoading();

    try {
      final user = await _authRepository.signIn(email: email, password: password);

      if (user == null) throw FirebaseAuthException(code: 'null-user', message: 'Login failed');

      final userData = await _userRepository.getUser(user.uid);
      appUser.value = userData;

      authState.value = BaseStateSuccess(null);

    } on FirebaseAuthException catch (e) {
      authState.value = BaseStateError(e.message ?? 'Login failed');
    } catch (e) {
      authState.value = BaseStateError('Unexpected error: $e');
    }
  }

  /// Sign out
  Future<void> logout() async {
    await _authRepository.signOut();
    // Firebase auth state change will clear firebaseUser and appUser
  }

  /// Is user authenticated
  bool get isLoggedIn => firebaseUser.value != null;
}
