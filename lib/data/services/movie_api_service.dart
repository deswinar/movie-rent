import 'package:movie_rent/core/constants/app_constants.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/core/services/base_api_service.dart';
import 'package:movie_rent/data/models/genre_model.dart';
import 'package:movie_rent/data/models/movie_explore_filter.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/data/responses/credits_response.dart';
import 'package:movie_rent/data/responses/genre_list_response.dart';
import 'package:movie_rent/data/responses/movie_response.dart';

class MovieApiService extends BaseApiService {
  @override
  String get baseUrl => AppConstants.baseUrl;

  @override
  Map<String, String>? get defaultHeaders => {
        'Authorization': 'Bearer ${AppConstants.tmdbBearerToken}',
        'Content-Type': 'application/json',
      };

  Future<MovieResponse> fetchMovies({
    required MovieCategory category,
    int page = 1,
    String language = 'en-US',
    String region = 'ID',
    String trendingTimeWindow = 'day', // Optional for trending movies
  }) async {
    final endpoint = category.path(timeWindow: trendingTimeWindow);
    final uri = '$endpoint?page=$page&language=$language&region=$region';

    return safeRequest<MovieResponse>(
      get(uri),
      onSuccess: (data) => MovieResponse.fromJson(data),
      fallbackErrorMessage: 'Failed to fetch ${category.name} movies',
    );
  }

  Future<MovieModel> fetchMovieDetail({
    required int id,
    String language = 'en-US',
    List<String>? appendToResponse,
  }) async {
    final queryParams = {
      'language': language,
      if (appendToResponse != null && appendToResponse.isNotEmpty)
        'append_to_response': appendToResponse.join(','),
    };

    final uri = Uri(path: '/movie/$id', queryParameters: queryParams);

    return safeRequest<MovieModel>(
      get(uri.toString()),
      onSuccess: (data) => MovieModel.fromJson(data),
      fallbackErrorMessage: 'Failed to fetch movie detail',
    );
  }

  Future<MovieResponse> searchMovies({
    required String query,
    int page = 1,
    String language = 'en-US',
    bool includeAdult = false,
  }) async {
    final uri =
        '/search/movie?query=$query&page=$page&language=$language&include_adult=$includeAdult';

    return safeRequest<MovieResponse>(
      get(uri),
      onSuccess: (data) => MovieResponse.fromJson(data),
      fallbackErrorMessage: 'Failed to search movies',
    );
  }

  Future<MovieResponse> discoverMovies(MovieExploreFilter filter) async {
    final queryParams = filter.toQueryParameters();
    final uri = Uri(path: '/discover/movie', queryParameters: queryParams);

    return safeRequest<MovieResponse>(
      get(uri.toString()),
      onSuccess: (data) => MovieResponse.fromJson(data),
      fallbackErrorMessage: 'Failed to discover movies',
    );
  }

  // Genres
  Future<List<GenreModel>> getGenres({String language = 'en-US'}) async {
    final uri = '/genre/movie/list?language=$language';

    return safeRequest<List<GenreModel>>(
      get(uri),
      onSuccess: (data) => GenreListResponse.fromJson(data).genres,
      fallbackErrorMessage: 'Failed to fetch genres',
    );
  }

  // Credits
  Future<CreditsResponse> fetchMovieCredits({
    required int movieId,
    String language = 'en-US',
  }) async {
    final uri = '/movie/$movieId/credits?language=$language';

    return safeRequest<CreditsResponse>(
      get(uri),
      onSuccess: (data) => CreditsResponse.fromJson(data),
      fallbackErrorMessage: 'Failed to fetch movie credits',
    );
  }
}
