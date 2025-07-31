import 'package:flutter/material.dart';
import 'package:movie_rent/data/models/movie_model.dart';

class MovieItemCard extends StatelessWidget {
  final MovieModel movie;

  const MovieItemCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: movie.posterPath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                    'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                    width: 60,
                    fit: BoxFit.cover,
                  ),
              )
            : const SizedBox(width: 60),
        title: Text(movie.title),
        subtitle: Text(
          movie.releaseDate,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
