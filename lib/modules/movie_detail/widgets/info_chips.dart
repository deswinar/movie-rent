import 'package:flutter/material.dart';
import 'package:movie_rent/data/models/movie_model.dart';

class InfoChips extends StatelessWidget {
  final MovieModel movie;
  const InfoChips({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipBackgroundColor = theme.chipTheme.backgroundColor ??
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2);
    return Wrap(
      spacing: 8,
      children: [
        Chip(
          label: Text('Release: ${movie.releaseDate}'),
          backgroundColor: chipBackgroundColor,
        ),
        Chip(
          label: Text('Language: ${movie.originalLanguage.toUpperCase()}'),
          backgroundColor: chipBackgroundColor,
        ),
        Chip(
          label: Text('Popularity: ${movie.popularity.toStringAsFixed(0)}'),
          backgroundColor: chipBackgroundColor,
        ),
        Chip(
          label: Text('Video: ${movie.video ? "Yes" : "No"}'),
          backgroundColor: chipBackgroundColor,
        ),
      ],
    );
  }
}
