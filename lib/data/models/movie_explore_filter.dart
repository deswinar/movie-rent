import 'package:equatable/equatable.dart';

class MovieExploreFilter extends Equatable {
  final String? language;
  final String? region;
  final bool includeAdult;
  final bool includeVideo;
  final int? page;
  final int? year;
  final String? sortBy;
  final String? withGenres;
  final List<int>? genreIds;
  final String? withKeywords;
  final double? voteAverageGte;
  final double? voteAverageLte;
  final int? voteCountGte;
  final int? voteCountLte;
  final String? releaseDateGte;
  final String? releaseDateLte;
  final int? withRuntimeGte;
  final int? withRuntimeLte;

  const MovieExploreFilter({
    this.language,
    this.region,
    this.includeAdult = false,
    this.includeVideo = false,
    this.page,
    this.year,
    this.sortBy,
    this.withGenres,
    this.genreIds,
    this.withKeywords,
    this.voteAverageGte,
    this.voteAverageLte,
    this.voteCountGte,
    this.voteCountLte,
    this.releaseDateGte,
    this.releaseDateLte,
    this.withRuntimeGte,
    this.withRuntimeLte,
  });

  MovieExploreFilter copyWith({
    String? language,
    String? region,
    bool? includeAdult,
    bool? includeVideo,
    int? page,
    int? year,
    String? sortBy,
    String? withGenres,
    List<int>? genreIds,
    String? withKeywords,
    double? voteAverageGte,
    double? voteAverageLte,
    int? voteCountGte,
    int? voteCountLte,
    String? releaseDateGte,
    String? releaseDateLte,
    int? withRuntimeGte,
    int? withRuntimeLte,

    // Nullable booleans to allow explicit nulling
    bool removeYear = false,
    bool removeSortBy = false,
    bool removeKeywords = false,
    bool removeRating = false,
    bool removeRelease = false,
    bool removeAdult = false,
  }) {
    return MovieExploreFilter(
      language: language ?? this.language,
      region: region ?? this.region,
      includeAdult: removeAdult ? false : (includeAdult ?? this.includeAdult),
      includeVideo: includeVideo ?? this.includeVideo,
      page: page ?? this.page,
      year: removeYear ? null : (year ?? this.year),
      sortBy: removeSortBy ? null : (sortBy ?? this.sortBy),
      withGenres: withGenres ?? this.withGenres,
      genreIds: genreIds ?? this.genreIds,
      withKeywords: removeKeywords ? null : (withKeywords ?? this.withKeywords),
      voteAverageGte: removeRating ? null : (voteAverageGte ?? this.voteAverageGte),
      voteAverageLte: removeRating ? null : (voteAverageLte ?? this.voteAverageLte),
      voteCountGte: voteCountGte ?? this.voteCountGte,
      voteCountLte: voteCountLte ?? this.voteCountLte,
      releaseDateGte: removeRelease ? null : (releaseDateGte ?? this.releaseDateGte),
      releaseDateLte: removeRelease ? null : (releaseDateLte ?? this.releaseDateLte),
      withRuntimeGte: withRuntimeGte ?? this.withRuntimeGte,
      withRuntimeLte: withRuntimeLte ?? this.withRuntimeLte,
    );
  }

  Map<String, String> toQueryParameters() {
    final Map<String, String> params = {};

    void put(String key, dynamic value) {
      if (value != null) {
        params[key] = value.toString();
      }
    }

    put('language', language ?? 'en-US');
    put('region', region ?? 'ID');
    put('include_adult', includeAdult);
    put('include_video', includeVideo);
    put('page', page ?? 1);
    put('year', year);
    put('sort_by', sortBy ?? 'popularity.desc');
    put('with_genres', genreIds?.join(',') ?? withGenres);
    put('with_keywords', withKeywords);
    put('vote_average.gte', voteAverageGte);
    put('vote_average.lte', voteAverageLte);
    put('vote_count.gte', voteCountGte);
    put('vote_count.lte', voteCountLte);
    put('release_date.gte', releaseDateGte);
    put('release_date.lte', releaseDateLte);
    put('with_runtime.gte', withRuntimeGte);
    put('with_runtime.lte', withRuntimeLte);

    return params;
  }

  @override
  List<Object?> get props => [
    language,
    region,
    includeAdult,
    includeVideo,
    page,
    year,
    sortBy,
    withGenres,
    genreIds,
    withKeywords,
    voteAverageGte,
    voteAverageLte,
    voteCountGte,
    voteCountLte,
    releaseDateGte,
    releaseDateLte,
    withRuntimeGte,
    withRuntimeLte,
  ];
}
