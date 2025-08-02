import 'package:equatable/equatable.dart';

class MovieDateRange extends Equatable {
  final String minimum;
  final String maximum;

  const MovieDateRange({
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

  @override
  List<Object> get props => [minimum, maximum];
}
