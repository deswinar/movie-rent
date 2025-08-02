import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/routes/app_routes.dart';

class MovieListTile extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onTap;

  const MovieListTile({super.key, required this.movie, this.onTap});

  void _defaultNavigation() {
    Get.toNamed(AppRoutes.movieDetail, arguments: movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap ?? _defaultNavigation,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          movie.posterPath != null ? 'https://image.tmdb.org/t/p/w92${movie.posterPath}' : '',
          width: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 50,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, size: 24),
          ),
        ),
      ),
      title: Text(
        movie.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: movie.overview.isNotEmpty
          ? Text(
              movie.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
