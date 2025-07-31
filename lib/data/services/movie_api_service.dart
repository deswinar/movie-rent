import 'package:movie_rent/core/constants/app_constants.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/core/services/base_api_service.dart';
import 'package:movie_rent/data/models/movie_model.dart';
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

  Future<MovieModel> fetchMovieDetail(int id) async {
    return safeRequest<MovieModel>(
      get('/movie/$id'),
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
}
