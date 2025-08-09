import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/helpers/filter_constraint.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_rent.dart';
import 'package:movie_rent/data/repositories/rent_repository.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';

class MyRentedMoviesController extends GetxController {
  final RentRepository _rentRepository;

  MyRentedMoviesController({required RentRepository rentRepository})
      : _rentRepository = rentRepository;

  final Rx<BaseState<List<MovieRent>>> rentedMoviesState =
      Rx<BaseState<List<MovieRent>>>(BaseStateInitial());

  final RxList<MovieRent> rentedMovies = <MovieRent>[].obs;

  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isFetching = false;

  static const int _limit = 10;

  // Dynamic filtering and sorting
  Map<String, FilterConstraint>? _filters;
  String _orderBy = 'rentDate';
  bool _descending = true;

  // Filtering UI options (for user input)
  final RxString selectedStatus = ''.obs; // 'active', 'expired', 'returned'
  final RxString sortBy = 'rentDate'.obs;
  final RxBool descending = true.obs;

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();
    ever(authController.firebaseUser, (user) {
      if (user != null) {
        fetchInitialRents(userId: user.uid);
      } else {
        rentedMovies.clear();
      }
    });
  }

  void applyUserFilters({
    String? status,
    String? sortField,
    bool? isDescending,
  }) {
    if (status != null) selectedStatus.value = status;
    if (sortField != null) sortBy.value = sortField;
    if (isDescending != null) descending.value = isDescending;

    // Build filter map
    final filters = <String, FilterConstraint>{};
    if (selectedStatus.value.isNotEmpty) {
      filters['status'] = FilterConstraint(isEqualTo: selectedStatus.value);
    }

    setFilters(filters);
    setSorting(orderBy: sortBy.value, descending: descending.value);
  }

  // Public filter setters
  void setFilters(Map<String, FilterConstraint>? filters) {
    _filters = filters;
    fetchInitialRents(userId: Get.find<AuthController>().firebaseUser.value!.uid);
  }

  void setSorting({required String orderBy, required bool descending}) {
    _orderBy = orderBy;
    _descending = descending;
    fetchInitialRents(userId: Get.find<AuthController>().firebaseUser.value!.uid);
  }

  /// Initial fetch
  Future<void> fetchInitialRents({required String userId}) async {
    rentedMovies.clear();
    _lastDocument = null;
    _hasMore = true;
    await fetchMoreRents(userId: userId);
  }

  /// Paginated fetch
  Future<void> fetchMoreRents({required String userId}) async {
    if (!_hasMore || _isFetching) return;

    _isFetching = true;

    if (rentedMovies.isEmpty) {
      rentedMoviesState.value = BaseStateLoading();
    }

    try {
      final newRents = await _rentRepository.getRentedMovies(
        userId: userId,
        limit: _limit,
        lastDoc: _lastDocument,
        filters: _filters,
        orderBy: _orderBy,
        descending: _descending,
      );

      if (newRents.length < _limit) _hasMore = false;

      // Update last document
      if (newRents.isNotEmpty) {
        _lastDocument = await _rentRepository.rentsRef(userId)
            .doc(newRents.last.rentId)
            .get();
      }

      rentedMovies.addAll(newRents);
      rentedMoviesState.value = BaseStateSuccess<List<MovieRent>>(rentedMovies.toList());
    } catch (e) {
      rentedMoviesState.value = BaseStateError("Failed to load rented movies.");
    } finally {
      _isFetching = false;
    }
  }

  /// UI helpers
  bool get isLoading => rentedMoviesState.value is BaseStateLoading;
  bool get hasError => rentedMoviesState.value is BaseStateError;
  String get errorMessage => rentedMoviesState.value.message ?? '';
  bool get hasMore => _hasMore;
}
