import 'package:movie_rent/data/models/cast_model.dart';
import 'package:movie_rent/data/models/crew_model.dart';

class CreditsResponse {
  final int id;
  final List<CastModel> cast;
  final List<CrewModel> crew;

  CreditsResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory CreditsResponse.fromJson(Map<String, dynamic> json) {
    return CreditsResponse(
      id: json['id'] ?? 0,
      cast: (json['cast'] as List).map((e) => CastModel.fromJson(e)).toList(),
      crew: (json['crew'] as List).map((e) => CrewModel.fromJson(e)).toList(),
    );
  }
}
