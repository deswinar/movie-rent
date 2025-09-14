import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/modules/movie_list/widgets/movie_list_view.dart';

void main() {
  // helper fake movie
  MovieModel makeMovie(int id, {bool adult = false}) {
    return MovieModel(
      id: id,
      title: 'Movie $id',
      originalTitle: 'Original $id',
      overview: 'Overview $id',
      posterPath: null,
      backdropPath: null,
      releaseDate: '2025-01-01',
      adult: adult,
      video: false,
      originalLanguage: 'en',
      popularity: 1.0,
      voteAverage: 5.0,
      voteCount: 100,
      genreIds: const [],
    );
  }

  testWidgets('renders movies and loader correctly', (tester) async {
    final movies = List.generate(3, (i) => makeMovie(i));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieListView(
            movies: movies,
            canLoadMore: true,
            onScrollEnd: () {},
          ),
        ),
      ),
    );

    // expect movies are rendered
    expect(find.text('Movie 0'), findsOneWidget);
    expect(find.text('Movie 1'), findsOneWidget);
    expect(find.text('Movie 2'), findsOneWidget);

    // loader should appear (since canLoadMore = true)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('does not render loader when canLoadMore = false', (tester) async {
    final movies = List.generate(2, (i) => makeMovie(i));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieListView(
            movies: movies,
            canLoadMore: false,
            onScrollEnd: () {},
          ),
        ),
      ),
    );

    expect(find.text('Movie 0'), findsOneWidget);
    expect(find.text('Movie 1'), findsOneWidget);

    // loader should not appear
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('triggers onScrollEnd when scrolled to bottom', (tester) async {
    final movies = List.generate(20, (i) => makeMovie(i));
    var called = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 400, // force scroll
            child: MovieListView(
              movies: movies,
              canLoadMore: true,
              onScrollEnd: () {
                called = true;
              },
            ),
          ),
        ),
      ),
    );

    // Scroll to the bottom
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();

    expect(called, true);
  });
}
