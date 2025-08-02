import 'package:flutter/material.dart';
import 'package:movie_rent/data/models/movie_model.dart';

class RatingSection extends StatelessWidget {
  final MovieModel movie;
  const RatingSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber[700], size: 20),
        const SizedBox(width: 4),
        Text('${movie.voteAverage.toStringAsFixed(1)} / 10'),
        const SizedBox(width: 8),
        Text('(${movie.voteCount} votes)'),
      ],
    );
  }
}
