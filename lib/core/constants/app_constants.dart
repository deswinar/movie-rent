import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final String baseUrl = 'https://api.themoviedb.org/3';
  static final String tmdbBearerToken = dotenv.env['TMDB_BEARER_TOKEN'] ?? '';
}