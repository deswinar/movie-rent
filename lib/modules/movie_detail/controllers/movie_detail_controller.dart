import 'package:get/get.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/cast_model.dart';
import 'package:movie_rent/data/models/crew_model.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/data/responses/credits_response.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';

class MovieDetailController extends GetxController {
  final MovieApiService _movieApiService;

  MovieDetailController(this._movieApiService);

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
}