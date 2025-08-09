import 'package:get/get.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_rent.dart';
import 'package:movie_rent/data/repositories/rent_repository.dart';

class RentController extends GetxController {
  final RentRepository _rentRepository;

  RentController({required RentRepository rentRepository})
      : _rentRepository = rentRepository;

  final rentsState = Rx<BaseState<List<MovieRent>>>(BaseStateInitial());
  final activeRents = <MovieRent>[].obs;
  final createRentState = Rx<BaseState<void>>(BaseStateInitial());

  Stream<List<MovieRent>> rentStream(String userId) {
    return _rentRepository.rentStream(userId);
  }

  Future<void> fetchActiveRents(String userId) async {
    rentsState.value = BaseStateLoading();
    try {
      final rents = await _rentRepository.getActiveRents(userId);
      activeRents.assignAll(rents);
      rentsState.value = BaseStateSuccess(rents);
    } catch (e) {
      rentsState.value = BaseStateError("Failed to fetch active rents.");
    }
  }

  Future<void> createRent(String userId, MovieRent rent) async {
    createRentState.value = BaseStateLoading();
    try {
      await _rentRepository.createRent(userId, rent);
      await fetchActiveRents(userId); // Refresh after creation
      createRentState.value = BaseStateSuccess(null);
    } catch (e) {
      Get.snackbar("Error", "Failed to create rent.");
      createRentState.value = BaseStateError("Failed to create rent.");
    }
  }

  Future<void> updateRentStatus({
    required String userId,
    required String rentId,
    required String status,
  }) async {
    try {
      await _rentRepository.updateRentStatus(userId, rentId, status);
      await fetchActiveRents(userId); // Refresh after update
    } catch (e) {
      Get.snackbar("Error", "Failed to update rent status.");
    }
  }

  MovieRent? findRentById(String rentId) {
    return activeRents.firstWhereOrNull((rent) => rent.rentId == rentId);
  }

  bool get isLoading => rentsState.value is BaseStateLoading;
  bool get hasError => rentsState.value is BaseStateError;
  String get errorMessage =>
      rentsState.value is BaseStateError ? (rentsState.value as BaseStateError).message : '';
}
