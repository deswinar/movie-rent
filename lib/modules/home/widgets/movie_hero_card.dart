import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/helpers/image_helper.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/routes/app_routes.dart';

class MovieHeroCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onTap;

  const MovieHeroCard({super.key, required this.movie, this.onTap});

  void _defaultNavigation() {
    Get.toNamed(AppRoutes.movieDetail, arguments: movie.id);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageHelper.getUrl(
      movie.backdropPath ?? movie.posterPath,
      size: 'w780',
    );

    return GestureDetector(
      onTap: onTap ?? _defaultNavigation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              )
            else
              const Center(child: Icon(Icons.broken_image)),
      
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  movie.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
