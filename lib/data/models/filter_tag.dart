class FilterTag {
  final String key;
  final String label;

  FilterTag({required this.key, required this.label});
}

List<FilterTag> filterTags = [
  FilterTag(key: 'query', label: 'Query'),
  FilterTag(key: 'genre', label: 'Genre'),
  FilterTag(key: 'vote', label: 'Vote'),
  FilterTag(key: 'year', label: 'Year'),
];