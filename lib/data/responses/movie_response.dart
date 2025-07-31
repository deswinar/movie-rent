import 'package:movie_rent/data/models/movie_date_range.dart';
import 'package:movie_rent/data/models/movie_model.dart';

class MovieResponse {
  final MovieDateRange? dates;
  final int page;
  final int totalPages;
  final int totalResults;
  final List<MovieModel> results;

  MovieResponse({
    this.dates,
    required this.page,
    required this.totalPages,
    required this.totalResults,
    required this.results,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      dates: json['dates'] != null
          ? MovieDateRange.fromJson(json['dates'])
          : null,
      page: json['page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalResults: json['total_results'] ?? 0,
      results: (json['results'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e))
          .toList(),
    );
  }
}
