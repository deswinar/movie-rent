import 'package:equatable/equatable.dart';

class MovieModel extends Equatable {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final bool adult;
  final bool video;
  final String originalLanguage;
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;

  const MovieModel({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.adult,
    required this.video,
    required this.originalLanguage,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'] ?? '',
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'adult': adult,
      'video': video,
      'original_language': originalLanguage,
      'popularity': popularity,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        originalTitle,
        overview,
        posterPath,
        backdropPath,
        releaseDate,
        adult,
        video,
        originalLanguage,
        popularity,
        voteAverage,
        voteCount,
        genreIds,
      ];
}
