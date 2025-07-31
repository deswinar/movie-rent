import 'package:get/get.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_model.dart';

class HomeController extends GetxController {
  final MovieApiService _movieApiService;

  HomeController({required MovieApiService movieApiService})
      : _movieApiService = movieApiService;

  final RxMap<MovieCategory, BaseState<List<MovieModel>>> moviePreviews = <MovieCategory, BaseState<List<MovieModel>>>{}.obs;

  final trendingTimeWindow = 'day'.obs;

  // Constants
  static const int previewLimit = 10;

  @override
  void onInit() {
    super.onInit();
    for (final category in MovieCategory.values) {
      _loadCategoryPreview(category);
    }
  }

  void _loadCategoryPreview(MovieCategory category) async {
    moviePreviews[category] = BaseStateLoading();

    try {
      final response = await _movieApiService.fetchMovies(
        category: category,
        page: 1,
        trendingTimeWindow: trendingTimeWindow.value,
      );

      final previewList = response.results.take(previewLimit).toList();

      moviePreviews[category] = BaseStateSuccess(previewList);
    } on ApiException catch (e) {
      moviePreviews[category] = BaseStateError(e.message);
    }
  }

  BaseState<List<MovieModel>> getCategoryState(MovieCategory category) {
    return moviePreviews[category] ?? BaseStateInitial();
  }

  List<MovieModel> getCategoryMovies(MovieCategory category) {
    final state = getCategoryState(category);
    return state is BaseStateSuccess<List<MovieModel>> ? state.data : [];
  }

  bool isLoading(MovieCategory category) => getCategoryState(category) is BaseStateLoading;
  bool isError(MovieCategory category) => getCategoryState(category) is BaseStateError;
  String errorMessage(MovieCategory category) {
    final state = getCategoryState(category);
    return state is BaseStateError ? (state as BaseStateError).message : 'Unknown error';
  }

  void refreshCategory(MovieCategory category) {
    _loadCategoryPreview(category);
  }

  void setTrendingTimeWindow(String timeWindow) {
    if (trendingTimeWindow.value != timeWindow) {
      trendingTimeWindow.value = timeWindow;
      refreshCategory(MovieCategory.trending);
    }
  }
}
