import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/data/responses/movie_response.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/modules/movie_list/controllers/movie_list_controller.dart';

class MockMovieApiService extends Mock implements MovieApiService {}

void main() {
  setUpAll(() {
    // register a safe dummy value for enum
    registerFallbackValue(MovieCategory.popular);
  });
  late MovieListController controller;
  late MockMovieApiService mockService;

  final sampleMovie = MovieModel(
    id: 1,
    title: "Test Movie",
    originalTitle: "Test Movie Original",
    overview: "Some overview",
    posterPath: "/poster.jpg",
    backdropPath: "/backdrop.jpg",
    releaseDate: "2025-01-01",
    adult: false,
    video: false,
    originalLanguage: "en",
    popularity: 123.4,
    voteAverage: 8.5,
    voteCount: 100,
    genreIds: [28, 12],
  );

  final sampleResponse = MovieResponse(
    page: 1,
    totalPages: 2,
    totalResults: 2,
    results: [sampleMovie],
  );

  setUp(() {
    mockService = MockMovieApiService();
    controller = MovieListController(movieApiService: mockService);
  });

  group("MovieListController", () {
    test("fetchInitialMovies success", () async {
      // arrange
      when(() => mockService.fetchMovies(
            category: any(named: "category"),
            page: any(named: "page"),
            trendingTimeWindow: any(named: "trendingTimeWindow"),
          )).thenAnswer((_) async => sampleResponse);

      // act
      await controller.fetchInitialMovies();

      // assert
      expect(controller.movieState.value, isA<BaseStateSuccess<List<MovieModel>>>());
      expect(controller.movies.length, 1);
      expect(controller.movies.first.title, "Test Movie");
    });

    test("fetchInitialMovies error", () async {
      // arrange
      when(() => mockService.fetchMovies(
            category: any(named: "category"),
            page: any(named: "page"),
            trendingTimeWindow: any(named: "trendingTimeWindow"),
          )).thenThrow(ApiException(message: "Network error", statusCode: 500));

      // act
      await controller.fetchInitialMovies();

      // assert
      expect(controller.movieState.value, isA<BaseStateError<List<MovieModel>>>());
      expect(controller.hasError, true);
      expect(controller.errorMessage, "Network error");
    });

    test("fetchMoreMovies success", () async {
      // arrange: first call returns page 1
      when(() => mockService.fetchMovies(
            category: any(named: "category"),
            page: 1,
            trendingTimeWindow: any(named: "trendingTimeWindow"),
          )).thenAnswer((_) async => sampleResponse);

      // second call returns page 2
      when(() => mockService.fetchMovies(
            category: any(named: "category"),
            page: 2,
            trendingTimeWindow: any(named: "trendingTimeWindow"),
          )).thenAnswer((_) async => MovieResponse(
                page: 2,
                totalPages: 2,
                totalResults: 2,
                results: [sampleMovie.copyWith(id: 2, title: "Movie 2")],
              ));

      // act
      await controller.fetchInitialMovies();
      await controller.fetchMoreMovies();

      // assert
      expect(controller.movies.length, 2);
      expect(controller.movies.last.title, "Movie 2");
    });

    test("fetchMoreMovies error rolls back page", () async {
      // arrange: page 1 success
      when(() => mockService.fetchMovies(
            category: any(named: "category"),
            page: 1,
            trendingTimeWindow: any(named: "trendingTimeWindow"),
          )).thenAnswer((_) async => sampleResponse);

      // page 2 throws error
      when(() => mockService.fetchMovies(
            category: any(named: "category"),
            page: 2,
            trendingTimeWindow: any(named: "trendingTimeWindow"),
          )).thenThrow(ApiException(message: "Server down", statusCode: 500));

      // act
      await controller.fetchInitialMovies();
      final beforePage = controller.movies.length;
      await controller.fetchMoreMovies();
      final afterPage = controller.movies.length;

      // assert
      expect(controller.hasError, true);
      expect(controller.errorMessage, "Server down");
      expect(beforePage, afterPage); // movies unchanged
    });
  });
}

extension MovieModelCopy on MovieModel {
  MovieModel copyWith({
    int? id,
    String? title,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      originalTitle: originalTitle,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      adult: adult,
      video: video,
      originalLanguage: originalLanguage,
      popularity: popularity,
      voteAverage: voteAverage,
      voteCount: voteCount,
      genreIds: genreIds,
    );
  }
}
