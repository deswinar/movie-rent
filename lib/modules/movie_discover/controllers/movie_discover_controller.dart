import 'package:get/get.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_explore_filter.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';

class MovieDiscoverController extends GetxController {
  final MovieApiService _movieApiService;

  MovieDiscoverController(this._movieApiService);

  final discoverState = Rx<BaseState<List<MovieModel>>>(BaseStateInitial());
  final Rx<MovieExploreFilter> filter = MovieExploreFilter().obs;

  int _currentPage = 1;
  int _totalPages = 1;
  final List<MovieModel> _results = [];

  List<MovieModel> get results => List.unmodifiable(_results);
  bool get canLoadMore => _currentPage < _totalPages;
  bool get isLoading => discoverState.value is BaseStateLoading;

  Future<void> discover({MovieExploreFilter? newFilter}) async {
    if (newFilter != null) filter.value = newFilter;
    _currentPage = 1;
    _totalPages = 1;
    _results.clear();
    discoverState.value = BaseStateLoading();

    try {
      final updatedFilter = filter.value.copyWith(page: _currentPage);
      final response = await _movieApiService.discoverMovies(updatedFilter);
      _totalPages = response.totalPages;
      _results.addAll(response.results);
      discoverState.value = BaseStateSuccess(List<MovieModel>.from(_results));
    } on ApiException catch (e) {
      discoverState.value = BaseStateError(e.message);
    }
  }

  Future<void> fetchMore() async {
    if (!canLoadMore || isLoading) return;

    _currentPage++;
    try {
      final response = await _movieApiService.discoverMovies(
        filter.value.copyWith(page: _currentPage),
      );
      _totalPages = response.totalPages;
      _results.addAll(response.results);
      discoverState.value = BaseStateSuccess(List<MovieModel>.from(_results));
    } on ApiException catch (e) {
      _currentPage--; // rollback
      discoverState.value = BaseStateError(e.message);
    }
  }
}
