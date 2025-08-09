import 'package:get/get.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/cast_model.dart';
import 'package:movie_rent/data/models/crew_model.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/data/repositories/rent_repository.dart';
import 'package:movie_rent/data/responses/credits_response.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';

class MovieDetailController extends GetxController {
  final MovieApiService _movieApiService;
  final RentRepository _rentRepository;

  MovieDetailController({
    required MovieApiService movieApiService,
    required RentRepository rentRepository,
  })  : _movieApiService = movieApiService,
        _rentRepository = rentRepository;

  final AuthController _authController = Get.find();

  final isAlreadyRented = false.obs;

  final movieDetailState = Rx<BaseState<MovieModel>>(BaseStateInitial());
  final creditsState = Rx<BaseState<CreditsResponse>>(BaseStateInitial());

  MovieModel? get movie =>
      movieDetailState.value is BaseStateSuccess<MovieModel>
          ? (movieDetailState.value as BaseStateSuccess<MovieModel>).data
          : null;

  CreditsResponse? get credits =>
      creditsState.value is BaseStateSuccess<CreditsResponse>
          ? (creditsState.value as BaseStateSuccess<CreditsResponse>).data
          : null;

  List<CastModel> get cast => credits?.cast ?? [];
  List<CrewModel> get crew => credits?.crew ?? [];

  bool get isLoading => movieDetailState.value is BaseStateLoading;
  bool get hasError => movieDetailState.value is BaseStateError;
  String get errorMessage =>
      (movieDetailState.value as BaseStateError).message;

  @override
  void onInit() {
    super.onInit();

    // Watch auth state and check rentals when user changes
    ever(_authController.firebaseUser, (user) {
      if (user != null && movie != null) {
        checkIfAlreadyRented(movieId: movie!.id);
      } else {
        isAlreadyRented.value = false;
      }
    });
  }

  Future<void> fetchMovieDetail({
    required int id,
    String language = 'en-US',
    List<String>? appendToResponse,
  }) async {
    movieDetailState.value = BaseStateLoading();

    try {
      final detail = await _movieApiService.fetchMovieDetail(
        id: id,
        language: language,
        appendToResponse: appendToResponse,
      );
      movieDetailState.value = BaseStateSuccess(detail);

      // If user already logged in, check immediately
      if (_authController.firebaseUser.value != null) {
        await checkIfAlreadyRented(movieId: id);
      }
    } on ApiException catch (e) {
      movieDetailState.value = BaseStateError(e.message);
    }
  }

  Future<void> fetchMovieCredits({
    required int id,
    String language = 'en-US',
  }) async {
    creditsState.value = BaseStateLoading();

    try {
      final response = await _movieApiService.fetchMovieCredits(movieId: id, language: language);
      creditsState.value = BaseStateSuccess(response);
    } on ApiException catch (e) {
      creditsState.value = BaseStateError(e.message);
    }
  }

  Future<void> checkIfAlreadyRented({required int movieId}) async {
    if (!_authController.isLoggedIn) {
      isAlreadyRented.value = false;
      return;
    }

    final userId = _authController.firebaseUser.value?.uid;
    final activeRents = await _rentRepository.getActiveRents(userId ?? '');

    isAlreadyRented.value = activeRents.any((rent) => rent.movieId == movieId);
  }
}