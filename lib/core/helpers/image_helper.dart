class ImageHelper {
  static const _baseUrl = 'https://image.tmdb.org/t/p/';
  static const _defaultSize = 'w500';

  static String? getUrl(String? path, {String size = _defaultSize}) {
    if (path == null || path.isEmpty) return null;
    return '$_baseUrl$size$path';
  }
}