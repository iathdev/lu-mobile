/// Mirrors the Go backend's response.APIResponse envelope:
/// { success, message, data, metadata, error }
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? metadata;
  final dynamic error;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.metadata,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      error: json['error'],
    );
  }
}

/// Mirrors the Go backend's dto.PaginationMeta:
/// { total, page, page_size, total_pages }
class PaginationMeta {
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  const PaginationMeta({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
      totalPages: json['total_pages'] as int,
    );
  }
}

/// Paginated response — data contains items + metadata
class PaginatedResponse<T> {
  final List<T> items;
  final PaginationMeta meta;

  const PaginatedResponse({
    required this.items,
    required this.meta,
  });

  bool get hasMore => meta.page < meta.totalPages;
}
