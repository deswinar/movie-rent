import 'package:get/get.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/app_user_model.dart';
import 'package:movie_rent/data/repositories/user_repository.dart';


class UserController extends GetxController {
  final UserRepository _userRepository;

  // BaseState to track user profile fetching
  final userState = Rx<BaseState<AppUser>>(BaseStateLoading());

  // Keep user stream subscription in memory
  Rx<AppUser?> currentUser = Rx<AppUser?>(null);

  UserController(this._userRepository);

  // Fetch single snapshot (once)
  Future<void> fetchUser(String uid) async {
    userState.value = BaseStateLoading<AppUser>();
    try {
      final user = await _userRepository.getUser(uid);
      if (user != null) {
        userState.value = BaseStateSuccess(user);
        currentUser.value = user;
      } else {
        userState.value = BaseStateError<AppUser>("User not found");
      }
    } catch (e) {
      userState.value = BaseStateError<AppUser>(e.toString());
    }
  }

  // Subscribe to real-time updates
  void listenToUser(String uid) {
    // Set initial state
    userState.value = BaseStateLoading<AppUser>();

    _userRepository.userStream(uid).listen(
      (user) {
        if (user != null) {
          userState.value = BaseStateSuccess(user);
          currentUser.value = user;
        } else {
          userState.value = BaseStateError<AppUser>("User not found");
        }
      },
      onError: (error) {
        userState.value = BaseStateError<AppUser>(error.toString());
      },
    );
  }

  // Create or update user
  Future<void> createOrUpdateUser(AppUser user) async {
    userState.value = BaseStateLoading<AppUser>();
    try {
      await _userRepository.createUser(user);
      userState.value = BaseStateSuccess(user);
      currentUser.value = user;
    } catch (e) {
      userState.value = BaseStateError<AppUser>(e.toString());
    }
  }

  // Update profile (partial)
  Future<void> updateProfile({
    required String uid,
    String? name,
  }) async {
    try {
      // Keep old state while updating
      await _userRepository.updateProfile(uid, name: name);

      // Optimistic update: merge into current user
      if (currentUser.value != null) {
        final updated = currentUser.value!.copyWith(
          name: name ?? currentUser.value!.name,
        );
        currentUser.value = updated;
        userState.value = BaseStateSuccess(updated);
      }
    } catch (e) {
      userState.value = BaseStateError<AppUser>(e.toString());
    }
  }
}
