import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lu_mobile/core/constants/storage_keys.dart';

/// Wrapper around [FlutterSecureStorage] for auth token management.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Read the Prep access token.
  Future<String?> getAccessToken() async {
    return _storage.read(key: StorageKeys.accessToken);
  }

  /// Save the Prep access token after SSO login.
  Future<void> setAccessToken(String token) async {
    await _storage.write(key: StorageKeys.accessToken, value: token);
  }

  /// Clear the token on logout or 401.
  Future<void> clearAccessToken() async {
    await _storage.delete(key: StorageKeys.accessToken);
  }

  /// Check if a token exists (for fast auth state check without reading value).
  Future<bool> hasAccessToken() async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  /// Clear all secure storage (full logout).
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
