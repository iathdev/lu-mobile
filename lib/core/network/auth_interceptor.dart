import 'package:dio/dio.dart';
import 'package:lu_mobile/core/storage/secure_storage.dart';

/// Injects Bearer token from SecureStorage into every request.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;

  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
