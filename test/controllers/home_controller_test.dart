import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_rent/core/enums/movie_category.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/data/responses/movie_response.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';
import 'package:movie_rent/modules/home/controllers/home_controller.dart';

class MockMovieApiService extends Mock implements MovieApiService {}

void main() {
  late HomeController controller;
  late MockMovieApiService mockService;

  setUp(() {
    mockService = MockMovieApiService();
    controller = HomeController(movieApiService: mockService);
    registerFallbackValue(MovieCategory.popular);
  });

  group('HomeController', () {
    final fakeMovies = List.generate(
      15,
      (i) => MovieModel(
        id: i,
        title: 'Movie $i',
        originalTitle: 'Original Movie $i',
        overview: 'Overview for movie $i',
        posterPath: '/poster_$i.jpg',
        backdropPath: '/backdrop_$i.jpg',
        releaseDate: '2025-01-01',
        adult: false,
        video: false,
        originalLanguage: 'en',
        popularity: 100.0 + i,
        voteAverage: 7.5,
        voteCount: 200 + i,
        genreIds: [28, 12],
      ),
    );
    final fakeResponse = MovieResponse(
      page: 1,
      totalPages: 1,
      totalResults: 15,
      results: fakeMovies,
    );

    test('onInit should load previews for all categories', () async {
      // Arrange
      when(() => mockService.fetchMovies(
            category: any(named: 'category'),
            page: any(named: 'page'),
            trendingTimeWindow: any(named: 'trendingTimeWindow'),
          )).thenAnswer((_) async => fakeResponse);

      // Act
      controller.onInit();
      await Future.delayed(Duration.zero);

      // Assert
      for (final category in MovieCategory.values) {
        final state = controller.getCategoryState(category);
        expect(state, isA<BaseStateSuccess<List<MovieModel>>>());
        final movies = controller.getCategoryMovies(category);
        expect(movies.length, 10); // preview limited to 10
      }
    });

    test('should set error state when API throws ApiException', () async {
      // Arrange
      when(() => mockService.fetchMovies(
            category: MovieCategory.popular,
            page: 1,
            trendingTimeWindow: any(named: 'trendingTimeWindow'),
          )).thenThrow(ApiException(message: 'API Error', statusCode: 500));

      // Act
      controller.refreshCategory(MovieCategory.popular);

      // Assert
      expect(controller.isError(MovieCategory.popular), true);
      expect(controller.errorMessage(MovieCategory.popular), 'API Error');
    });

    test('refreshCategory should reload the given category', () async {
      // Arrange
      when(() => mockService.fetchMovies(
            category: MovieCategory.topRated,
            page: 1,
            trendingTimeWindow: any(named: 'trendingTimeWindow'),
          )).thenAnswer((_) async => fakeResponse);

      // Act
      controller.refreshCategory(MovieCategory.topRated);
      await Future.delayed(Duration.zero);

      // Assert
      final state = controller.getCategoryState(MovieCategory.topRated);
      expect(state, isA<BaseStateSuccess<List<MovieModel>>>());
    });

    test('setTrendingTimeWindow should update and refresh trending category',
        () async {
      // Arrange
      when(() => mockService.fetchMovies(
            category: MovieCategory.trending,
            page: 1,
            trendingTimeWindow: 'week',
          )).thenAnswer((_) async => fakeResponse);

      // Act
      controller.setTrendingTimeWindow('week');

      // Assert
      expect(controller.trendingTimeWindow.value, 'week');
      final state = controller.getCategoryState(MovieCategory.trending);
      // Note: async call, so state may first be loading
      expect(state is BaseStateLoading || state is BaseStateSuccess<List<MovieModel>>, true);
    });
  });
}
