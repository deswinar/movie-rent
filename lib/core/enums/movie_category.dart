enum MovieCategory {
  popular,
  trending,
  nowPlaying,
  topRated,
  upcoming,
}

extension MovieCategoryPath on MovieCategory {
  String path({String timeWindow = 'day'}) {
    switch (this) {
      case MovieCategory.nowPlaying:
        return '/movie/now_playing';
      case MovieCategory.popular:
        return '/movie/popular';
      case MovieCategory.topRated:
        return '/movie/top_rated';
      case MovieCategory.upcoming:
        return '/movie/upcoming';
      case MovieCategory.trending:
        return '/trending/movie/$timeWindow';
    }
  }
}

extension MovieCategoryLabel on MovieCategory {
  String get label {
    switch (this) {
      case MovieCategory.nowPlaying:
        return 'Now Playing';
      case MovieCategory.popular:
        return 'Popular';
      case MovieCategory.topRated:
        return 'Top Rated';
      case MovieCategory.upcoming:
        return 'Upcoming';
      case MovieCategory.trending:
        return 'Trending';
    }
  }
}

