/// Base class for all API exceptions.
sealed class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

/// 401 — token expired or revoked.
class UnauthorizedException extends ApiException {
  final String? returnUrl;

  const UnauthorizedException({
    super.message = 'Unauthorized',
    super.statusCode = 401,
    this.returnUrl,
  });
}

/// 403 — feature not entitled.
class FeatureNotEntitledException extends ApiException {
  final String? feature;
  final String? currentPlan;
  final String? upgradeCta;

  const FeatureNotEntitledException({
    super.message = 'Feature not entitled',
    super.statusCode = 403,
    this.feature,
    this.currentPlan,
    this.upgradeCta,
  });
}

/// 404 — resource not found.
class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'Not found',
    super.statusCode = 404,
  });
}

/// 422 — validation error.
class ValidationException extends ApiException {
  const ValidationException({
    super.message = 'Validation failed',
    super.statusCode = 422,
    super.data,
  });
}

/// 429 — quota exceeded.
class QuotaExceededException extends ApiException {
  final String? feature;
  final int? limit;
  final int? used;
  final int? remaining;
  final DateTime? resetsAt;
  final String? upgradeCta;

  const QuotaExceededException({
    super.message = 'Quota exceeded',
    super.statusCode = 429,
    this.feature,
    this.limit,
    this.used,
    this.remaining,
    this.resetsAt,
    this.upgradeCta,
  });
}

/// 503 — service unavailable (circuit breaker).
class ServiceUnavailableException extends ApiException {
  const ServiceUnavailableException({
    super.message = 'Service unavailable',
    super.statusCode = 503,
  });
}

/// Network / connectivity error.
class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
  });
}

/// Catch-all for unexpected errors.
class UnexpectedException extends ApiException {
  const UnexpectedException({
    super.message = 'An unexpected error occurred',
    super.statusCode,
    super.data,
  });
}
