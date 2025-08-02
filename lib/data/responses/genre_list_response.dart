import 'package:equatable/equatable.dart';
import 'package:movie_rent/data/models/genre_model.dart';

class GenreListResponse extends Equatable {
  final List<GenreModel> genres;

  const GenreListResponse({required this.genres});

  factory GenreListResponse.fromJson(Map<String, dynamic> json) {
    final list = json['genres'] as List;
    return GenreListResponse(
      genres: list.map((e) => GenreModel.fromJson(e)).toList(),
    );
  }

  @override
  List<Object> get props => [genres];
}
