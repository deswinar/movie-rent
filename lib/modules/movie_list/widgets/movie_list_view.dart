import 'package:flutter/material.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/modules/movie_list/widgets/movie_item_card.dart';

class MovieListView extends StatelessWidget {
  final List<MovieModel> movies;
  final VoidCallback onScrollEnd;
  final bool canLoadMore;

  const MovieListView({
    super.key,
    required this.movies,
    required this.onScrollEnd,
    required this.canLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent * 0.9 &&
            canLoadMore) {
          onScrollEnd();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: movies.length + (canLoadMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == movies.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final movie = movies[index];
          return MovieItemCard(movie: movie);
        },
      ),
    );
  }
}
