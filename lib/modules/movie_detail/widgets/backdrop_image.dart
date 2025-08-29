import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_rent/core/helpers/image_helper.dart';
import 'package:movie_rent/core/widgets/app_loader.dart';
import 'package:movie_rent/data/models/movie_model.dart';

class BackdropImage extends StatelessWidget {
  final MovieModel movie;
  const BackdropImage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageHelper.getUrl(movie.backdropPath, size: 'w780');

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const AppLoader(),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image)),
              ),
            )
          : Container(color: Colors.grey[300]),
    );
  }
}
