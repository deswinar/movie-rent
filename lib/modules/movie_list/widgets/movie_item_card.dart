import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/helpers/image_helper.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/routes/app_routes.dart';

class MovieItemCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onTap;

  const MovieItemCard({
    super.key,
    required this.movie,
    this.onTap,
  });

  void _defaultNavigation() {
    Get.toNamed(AppRoutes.movieDetail, arguments: movie.id);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageHelper.getUrl(
      movie.posterPath,
      size: 'w92',
    );

    return GestureDetector(
      onTap: onTap ?? _defaultNavigation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: movie.posterPath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    imageUrl ?? '',
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      width: 60,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                )
              : const SizedBox(width: 60),
      
          // Title with optional adult badge
          title: Row(
            children: [
              Expanded(
                child: Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (movie.adult)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '18+',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
      
          subtitle: Text(
            movie.releaseDate,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
