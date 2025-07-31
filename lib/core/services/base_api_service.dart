import 'dart:developer';
import 'package:get/get.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';

abstract class BaseApiService extends GetConnect {
  @override
  String get baseUrl;
  Map<String, String>? get defaultHeaders;

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;

    if (defaultHeaders != null) {
      httpClient.addRequestModifier<void>((request) async {
        request.headers.addAll(defaultHeaders!);
        return request;
      });
    }

    httpClient.timeout = const Duration(seconds: 15);
    super.onInit();
  }

  // Error handling wrapper
  Future<T> safeRequest<T>(
    Future<Response> request, {
    T Function(dynamic data)? onSuccess,
    String? fallbackErrorMessage,
  }) async {
    try {
      final response = await request;

      if (response.isOk && response.body != null) {
        return onSuccess != null
            ? onSuccess(response.body)
            : response.body as T;
      } else {
        throw ApiException.fromResponse(response);
      }
    } catch (e, stack) {
      log('API Error: $e', stackTrace: stack);
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException(
          message: fallbackErrorMessage ?? 'Unknown error occurred.',
          statusCode: -1,
        );
      }
    }
  }
}
