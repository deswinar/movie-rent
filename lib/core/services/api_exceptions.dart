import 'package:get/get.dart';

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => 'ApiException ($statusCode): $message';

  factory ApiException.fromResponse(Response response) {
    final status = response.statusCode ?? -1;
    final dynamic data = response.body;

    String message = 'Unknown error occurred';

    if (data is Map<String, dynamic> && data['status_message'] != null) {
      message = data['status_message'];
    } else if (response.statusText != null) {
      message = response.statusText!;
    }

    return ApiException(message: message, statusCode: status);
  }
}
