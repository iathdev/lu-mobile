import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

/// Injects X-Lang header based on the app's current locale.
class LanguageInterceptor extends Interceptor {
  final ValueGetter<Locale> _localeGetter;

  LanguageInterceptor(this._localeGetter);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final locale = _localeGetter();
    options.headers['X-Lang'] = locale.languageCode;
    handler.next(options);
  }
}
