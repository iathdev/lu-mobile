import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_mobile/core/storage/secure_storage.dart';

/// Authentication state — tracks whether user is logged in.
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = true,
  });

  AuthState copyWith({bool? isAuthenticated, bool? isLoading}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  SecureStorageService get _storage => ref.read(secureStorageProvider);

  /// Check if user has a stored token on app launch.
  Future<void> checkAuthStatus() async {
    final hasToken = await _storage.hasAccessToken();
    state = AuthState(isAuthenticated: hasToken, isLoading: false);
  }

  /// Called after successful SSO login — store token and update state.
  Future<void> login(String accessToken) async {
    await _storage.setAccessToken(accessToken);
    state = const AuthState(isAuthenticated: true, isLoading: false);
  }

  /// Logout — clear token and reset state.
  Future<void> logout() async {
    await _storage.clearAll();
    state = const AuthState(isAuthenticated: false, isLoading: false);
  }

  /// Called on 401 — token expired or revoked.
  Future<void> onUnauthorized() async {
    await _storage.clearAccessToken();
    state = const AuthState(isAuthenticated: false, isLoading: false);
  }
}

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
