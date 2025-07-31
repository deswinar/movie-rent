import 'package:get/get.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';

class MovieSearchController extends GetxController {
  final MovieApiService _movieApiService;

  MovieSearchController(this._movieApiService);

  final searchState = Rx<BaseState<List<MovieModel>>>(BaseStateInitial<List<MovieModel>>());
  final RxString query = ''.obs;

  int _currentPage = 1;
  int _totalPages = 1;
  final List<MovieModel> _results = [];

  List<MovieModel> get results => List.unmodifiable(_results);
  bool get canLoadMore => _currentPage < _totalPages;
  bool get isLoading => searchState.value is BaseStateLoading;

  Future<void> search(String newQuery) async {
    query.value = newQuery;
    _currentPage = 1;
    _totalPages = 1;
    _results.clear();
    searchState.value = BaseStateLoading();

    try {
      final response = await _movieApiService.searchMovies(query: newQuery, page: _currentPage);
      _totalPages = response.totalPages;
      _results.addAll(response.results);
      searchState.value = BaseStateSuccess(List<MovieModel>.from(_results));
    } on ApiException catch (e) {
      searchState.value = BaseStateError(e.message);
    }
  }

  Future<void> fetchMore() async {
    if (!canLoadMore || isLoading) return;

    _currentPage++;
    try {
      final response = await _movieApiService.searchMovies(query: query.value, page: _currentPage);
      _totalPages = response.totalPages;
      _results.addAll(response.results);
      searchState.value = BaseStateSuccess(List<MovieModel>.from(_results));
    } on ApiException catch (e) {
      _currentPage--; // rollback
      searchState.value = BaseStateError(e.message);
    }
  }
}
