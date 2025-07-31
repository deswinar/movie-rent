class MovieDateRange {
  final String minimum;
  final String maximum;

  MovieDateRange({
    required this.minimum,
    required this.maximum,
  });

  factory MovieDateRange.fromJson(Map<String, dynamic> json) {
    return MovieDateRange(
      minimum: json['minimum'] ?? '',
      maximum: json['maximum'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minimum': minimum,
      'maximum': maximum,
    };
  }
}
