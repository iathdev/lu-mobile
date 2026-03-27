import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_mobile/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported locales matching the backend's i18n.
const supportedLocales = [
  Locale('en'),
  Locale('vi'),
  Locale('zh'),
  Locale('th'),
  Locale('id'),
];

/// Manages the app's current locale, persisted in SharedPreferences.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final saved = prefs.getString(StorageKeys.locale);
    if (saved != null) {
      return Locale(saved);
    }
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final isSupported = supportedLocales.any(
      (l) => l.languageCode == deviceLocale.languageCode,
    );
    return isSupported ? Locale(deviceLocale.languageCode) : const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(StorageKeys.locale, locale.languageCode);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
