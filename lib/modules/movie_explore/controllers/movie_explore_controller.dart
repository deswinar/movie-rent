import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:movie_rent/core/enums/sort_option.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_explore_filter.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/modules/genre/controllers/genre_controller.dart';

class MovieExploreController extends GetxController {
  final MovieApiService _movieApiService;

  MovieExploreController(this._movieApiService);

  final GenreController _genreController = Get.find();

  final exploreState = Rx<BaseState<List<MovieModel>>>(BaseStateInitial());

  final RxString query = ''.obs;
  final Rx<MovieExploreFilter> filter = MovieExploreFilter().obs;

  final RxList<String> activeTags = <String>[].obs;

  int _currentPage = 1;
  int _totalPages = 1;
  final List<MovieModel> _results = [];

  List<MovieModel> get results => List.unmodifiable(_results);
  bool get canLoadMore => _currentPage < _totalPages;
  bool get isLoading => exploreState.value is BaseStateLoading;
  bool get isSearchMode => query.value.trim().isNotEmpty;

  Future<void> fetchInitial({String? newQuery, MovieExploreFilter? newFilter}) async {
    if (newQuery != null) {
      await search(newQuery);
    } else if (newFilter != null) {
      await discover(newFilter);
    } else {
      await discover(filter.value);
    }
  }

  Future<void> search(String newQuery) async {
    query.value = newQuery;
    _currentPage = 1;
    _totalPages = 1;
    _results.clear();
    exploreState.value = BaseStateLoading();

    try {
      final response = await _movieApiService.searchMovies(
        query: newQuery,
        page: _currentPage,
      );
      _totalPages = response.totalPages;
      _results.addAll(response.results);
      _generateActiveTags();
      exploreState.value = BaseStateSuccess(List<MovieModel>.from(_results));
    } on ApiException catch (e) {
      exploreState.value = BaseStateError(e.message);
    }
  }

  Future<void> discover(MovieExploreFilter? newFilter) async {
    if (newFilter != null) filter.value = newFilter;

    query.value = ''; // Reset search mode
    _currentPage = 1;
    _totalPages = 1;
    _results.clear();
    exploreState.value = BaseStateLoading();

    try {
      final updatedFilter = filter.value.copyWith(page: _currentPage);
      final response = await _movieApiService.discoverMovies(updatedFilter);
      _totalPages = response.totalPages;
      _results.addAll(response.results);
      _generateActiveTags();
      exploreState.value = BaseStateSuccess(List<MovieModel>.from(_results));
    } on ApiException catch (e) {
      exploreState.value = BaseStateError(e.message);
    }
  }

  Future<void> fetchMore() async {
    if (!canLoadMore || isLoading) return;

    _currentPage++;
    try {
      final response = isSearchMode
          ? await _movieApiService.searchMovies(
              query: query.value,
              page: _currentPage,
            )
          : await _movieApiService.discoverMovies(
              filter.value.copyWith(page: _currentPage),
            );

      _totalPages = response.totalPages;
      _results.addAll(response.results);
      exploreState.value = BaseStateSuccess(List<MovieModel>.from(_results));
    } on ApiException catch (e) {
      _currentPage--; // rollback
      exploreState.value = BaseStateError(e.message);
    }
  }
  
  void _generateActiveTags() {
    final tags = <String>[];

    if (query.value.trim().isNotEmpty) {
      tags.add('Search: "${query.value.trim()}"');
    }

    final f = filter.value;
    if (f.year != null) tags.add('Year: ${f.year}');
    if (f.sortBy != null) {
      tags.add('Sort: ${SortOptionExtension.fromApiValue(f.sortBy ?? 'popularity.desc').label}');
    }
    if ((f.genreIds?.isNotEmpty ?? false)) {
      final genreNames = f.genreIds!
          .map((id) => _genreController.genreMap[id])
          .whereType<String>()
          .toList();

      tags.add('Genres: ${genreNames.join(', ')}');
    }
    if (f.withKeywords?.isNotEmpty ?? false) tags.add('Keywords: ${f.withKeywords}');
    if (f.voteAverageGte != null || f.voteAverageLte != null) {
      final gte = f.voteAverageGte?.toStringAsFixed(1) ?? '0';
      final lte = f.voteAverageLte?.toStringAsFixed(1) ?? '10';
      tags.add('Rating: $gte–$lte');
    }

    // Format release dates
    String formatDate(String? dateStr) {
      if (dateStr == null) return 'Any';
      try {
        final date = DateTime.parse(dateStr);
        return DateFormat('MMM dd, yyyy').format(date); // e.g., Jan 01, 2020
      } catch (_) {
        return dateStr;
      }
    }

    final releaseFrom = formatDate(f.releaseDateGte);
    final releaseTo = formatDate(f.releaseDateLte);
    if (f.releaseDateGte != null || f.releaseDateLte != null) {
      tags.add('Release: $releaseFrom to $releaseTo');
    }

    if (f.includeAdult) tags.add('Adult: Yes');

    activeTags.value = tags;
  }

  void clearSearch() {
    query.value = '';
    fetchInitial();
  }

  void clearFilters() {
    filter.value = const MovieExploreFilter();
    fetchInitial();
  }

  void removeTag(String tag) {
    if (tag.startsWith('Search:')) {
      clearSearch();
      return;
    }

    final f = filter.value;

    if (tag.startsWith('Year:')) {
      filter.value = f.copyWith(removeYear: true);
    }

    if (tag.startsWith('Sort:')) {
      filter.value = f.copyWith(removeSortBy: true);
    }

    if (tag.startsWith('Genres:')) {
      filter.value = f.copyWith(genreIds: []);
    }

    if (tag.startsWith('Keywords:')) {
      filter.value = f.copyWith(removeKeywords: true);
    }

    if (tag.startsWith('Rating:')) {
      filter.value = f.copyWith(removeRating: true);
    }

    if (tag.startsWith('Release:')) {
      filter.value = f.copyWith(removeRelease: true);
    }

    if (tag.startsWith('Adult:')) {
      filter.value = f.copyWith(removeAdult: true);
    }

    fetchInitial();
  }

  void clearAllTags() {
    query.value = '';
    filter.value = const MovieExploreFilter();
    fetchInitial();
  }
}
