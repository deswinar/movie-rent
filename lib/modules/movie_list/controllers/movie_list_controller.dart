import 'package:get/get.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_model.dart';

class MovieListController extends GetxController {
  final MovieApiService _movieApiService;

  MovieListController({
    required MovieApiService movieApiService,
  }) : _movieApiService = movieApiService;

  final movieState = Rx<BaseState<List<MovieModel>>>(BaseStateInitial());

  final Rx<MovieCategory> _category = MovieCategory.popular.obs;
  set category(MovieCategory value) => _category.value = value;
  MovieCategory get category => _category.value;

  final RxString _trendingTimeWindow = 'day'.obs;
  set trendingTimeWindow(String value) => _trendingTimeWindow.value = value;
  String get trendingTimeWindow => _trendingTimeWindow.value;

  int _currentPage = 1;
  int _totalPages = 1;
  final List<MovieModel> _movies = [];

  bool get isLoading => movieState.value is BaseStateLoading;
  bool get hasError => movieState.value is BaseStateError;
  String get errorMessage => (movieState.value as BaseStateError).message;
  List<MovieModel> get movies => List.unmodifiable(_movies);
  bool get canLoadMore => _currentPage < _totalPages;

  Future<void> fetchInitialMovies() async {
    _currentPage = 1;
    _totalPages = 1;
    _movies.clear();
    movieState.value = BaseStateLoading();

    try {
      final response = await _movieApiService.fetchMovies(
        category: _category.value,
        page: _currentPage,
        trendingTimeWindow: _category.value == MovieCategory.trending
            ? _trendingTimeWindow.value
            : '',
      );

      _totalPages = response.totalPages;
      _movies.addAll(response.results);
      movieState.value = BaseStateSuccess(List<MovieModel>.from(_movies));
    } on ApiException catch (e) {
      movieState.value = BaseStateError(e.message);
    }
  }

  Future<void> fetchMoreMovies() async {
    if (!canLoadMore || isLoading) return;

    _currentPage++;
    movieState.value = BaseStateSuccess(List<MovieModel>.from(_movies));

    try {
      final response = await _movieApiService.fetchMovies(
        category: _category.value,
        page: _currentPage,
        trendingTimeWindow: _category.value == MovieCategory.trending
            ? _trendingTimeWindow.value
            : '',
      );

      _totalPages = response.totalPages;
      _movies.addAll(response.results);
      movieState.value = BaseStateSuccess(List<MovieModel>.from(_movies));
    } on ApiException catch (e) {
      _currentPage--; // rollback
      movieState.value = BaseStateError(e.message);
    }
  }
}
