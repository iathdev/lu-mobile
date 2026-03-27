import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:lu_mobile/core/constants/api_constants.dart';
import 'package:lu_mobile/core/network/auth_interceptor.dart';
import 'package:lu_mobile/core/network/error_interceptor.dart';
import 'package:lu_mobile/core/network/language_interceptor.dart';
import 'package:lu_mobile/core/storage/secure_storage.dart';

/// Central Dio-based HTTP client for the Go backend.
///
/// Interceptor order:
/// 1. [AuthInterceptor] — inject Bearer token
/// 2. [LanguageInterceptor] — inject X-Lang header
/// 3. [ErrorInterceptor] — unwrap envelope + map errors
class ApiClient {
  late final Dio dio;

  ApiClient({
    required SecureStorageService storage,
    required ValueGetter<Locale> localeGetter,
    String? baseUrl,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(storage),
      LanguageInterceptor(localeGetter),
      ErrorInterceptor(),
    ]);
  }

  /// GET request. Response data is already unwrapped from envelope.
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? decoder,
  }) async {
    final response = await dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
    );
    return decoder != null ? decoder(response.data) : response.data as T;
  }

  /// GET with full Response (for accessing metadata in response.extra).
  Future<Response<dynamic>> getRaw(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return dio.get<dynamic>(path, queryParameters: queryParameters);
  }

  /// POST request with JSON body.
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? decoder,
  }) async {
    final response = await dio.post<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return decoder != null ? decoder(response.data) : response.data as T;
  }

  /// PUT request.
  Future<T> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? decoder,
  }) async {
    final response = await dio.put<dynamic>(path, data: data);
    return decoder != null ? decoder(response.data) : response.data as T;
  }

  /// DELETE request.
  Future<T> delete<T>(
    String path, {
    T Function(dynamic)? decoder,
  }) async {
    final response = await dio.delete<dynamic>(path);
    return decoder != null ? decoder(response.data) : response.data as T;
  }

  /// Multipart POST (for OCR image upload).
  Future<T> postMultipart<T>(
    String path, {
    required FormData formData,
    Map<String, String>? headers,
    T Function(dynamic)? decoder,
  }) async {
    final response = await dio.post<dynamic>(
      path,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          ...?headers,
        },
      ),
    );
    return decoder != null ? decoder(response.data) : response.data as T;
  }
}
