enum SortOption {
  popularityDesc,
  popularityAsc,
  voteAverageDesc,
  voteAverageAsc,
  releaseDateDesc,
  releaseDateAsc,
}

extension SortOptionExtension on SortOption {
  String get label {
    switch (this) {
      case SortOption.popularityDesc:
        return 'Most Popular';
      case SortOption.popularityAsc:
        return 'Least Popular';
      case SortOption.voteAverageDesc:
        return 'Highest Rated';
      case SortOption.voteAverageAsc:
        return 'Lowest Rated';
      case SortOption.releaseDateDesc:
        return 'Newest Releases';
      case SortOption.releaseDateAsc:
        return 'Oldest Releases';
    }
  }

  String get apiValue {
    switch (this) {
      case SortOption.popularityDesc:
        return 'popularity.desc';
      case SortOption.popularityAsc:
        return 'popularity.asc';
      case SortOption.voteAverageDesc:
        return 'vote_average.desc';
      case SortOption.voteAverageAsc:
        return 'vote_average.asc';
      case SortOption.releaseDateDesc:
        return 'release_date.desc';
      case SortOption.releaseDateAsc:
        return 'release_date.asc';
    }
  }

  static SortOption fromApiValue(String value) {
    return SortOption.values.firstWhere(
      (option) => option.apiValue == value,
      orElse: () => SortOption.popularityDesc,
    );
  }
}
