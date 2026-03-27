import 'package:dio/dio.dart';
import 'package:lu_mobile/core/network/api_exception.dart';

/// Intercepts API responses:
/// 1. Unwraps the { success, message, data } envelope on success.
/// 2. Maps HTTP errors to typed [ApiException]s.
class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final data = response.data;

    // Unwrap envelope: if response has { success, data }, extract data
    if (data is Map<String, dynamic> && data.containsKey('success')) {
      if (data['success'] == true) {
        // Replace response data with the inner `data` field
        response.data = data['data'];
        // Store metadata separately if needed
        if (data['metadata'] != null) {
          response.extra['metadata'] = data['metadata'];
        }
      } else {
        // success: false — treat as error
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            message: data['message'] as String? ?? 'Request failed',
          ),
        );
        return;
      }
    }

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final statusCode = err.response?.statusCode;
    final responseData = err.response?.data;
    final message = _extractMessage(responseData) ?? err.message ?? 'Unknown error';

    final ApiException exception = switch (statusCode) {
      401 => UnauthorizedException(
          message: message,
          returnUrl: _extractField(responseData, 'data', 'return_url'),
        ),
      403 => _parse403(responseData, message),
      404 => NotFoundException(message: message),
      422 => ValidationException(message: message, data: responseData),
      429 => _parse429(responseData, message),
      503 => ServiceUnavailableException(message: message),
      _ => _handleOther(err, statusCode, message),
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }

  ApiException _parse403(dynamic data, String message) {
    if (data is Map<String, dynamic>) {
      final details = data['error'] as Map<String, dynamic>?;
      if (details != null && details['code'] == 'FEATURE_NOT_ENTITLED') {
        return FeatureNotEntitledException(
          message: message,
          feature: details['feature'] as String?,
          currentPlan: details['current_plan'] as String?,
          upgradeCta: details['upgrade_cta'] as String?,
        );
      }
    }
    return FeatureNotEntitledException(message: message);
  }

  ApiException _parse429(dynamic data, String message) {
    if (data is Map<String, dynamic>) {
      final details = data['error'] as Map<String, dynamic>?;
      if (details != null) {
        return QuotaExceededException(
          message: message,
          feature: details['feature'] as String?,
          limit: details['limit'] as int?,
          used: details['used'] as int?,
          remaining: details['remaining'] as int?,
          resetsAt: details['resets_at'] != null
              ? DateTime.tryParse(details['resets_at'] as String)
              : null,
          upgradeCta: details['upgrade_cta'] as String?,
        );
      }
    }
    return QuotaExceededException(message: message);
  }

  ApiException _handleOther(DioException err, int? statusCode, String message) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }
    return UnexpectedException(
      message: message,
      statusCode: statusCode,
      data: err.response?.data,
    );
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String?;
    }
    return null;
  }

  String? _extractField(dynamic data, String key, String nestedKey) {
    if (data is Map<String, dynamic>) {
      final nested = data[key];
      if (nested is Map<String, dynamic>) {
        return nested[nestedKey] as String?;
      }
    }
    return null;
  }
}
