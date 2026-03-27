import 'package:lu_mobile/core/constants/api_constants.dart';
import 'package:lu_mobile/core/domain/pagination.dart';
import 'package:lu_mobile/core/network/api_client.dart';
import 'package:lu_mobile/core/network/api_response.dart';
import 'package:lu_mobile/features/vocabulary/data/models/vocabulary_model.dart';

class VocabularyRepository {
  final ApiClient _client;

  VocabularyRepository(this._client);

  /// Fetch HSK vocabulary list from API.
  /// After ErrorInterceptor: response.data = list of items, response.extra['metadata'] = pagination.
  Future<PaginatedResponse<VocabularyListItem>> listByHskLevel(
    int level, {
    PaginationParams params = const PaginationParams(),
  }) async {
    final response = await _client.getRaw(
      ApiConstants.hskLevel(level),
      queryParameters: params.toQueryParameters(),
    );

    final rawData = response.data;
    final rawMeta = response.extra['metadata'];

    final List<VocabularyListItem> items;
    if (rawData is List) {
      items = rawData
          .map((e) => VocabularyListItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      items = [];
    }

    final meta = rawMeta is Map<String, dynamic>
        ? PaginationMeta.fromJson(rawMeta)
        : PaginationMeta(total: items.length, page: 1, pageSize: 20, totalPages: 1);

    return PaginatedResponse(items: items, meta: meta);
  }

  /// Fetch vocabulary detail.
  Future<VocabularyDetail> getDetail(String id) async {
    return _client.get<VocabularyDetail>(
      ApiConstants.vocabularyDetail(id),
      decoder: (d) => VocabularyDetail.fromJson(d as Map<String, dynamic>),
    );
  }

  /// Search vocabulary.
  Future<PaginatedResponse<VocabularyListItem>> search(
    String query, {
    PaginationParams params = const PaginationParams(),
  }) async {
    final response = await _client.getRaw(
      ApiConstants.searchVocabularies,
      queryParameters: {
        'q': query,
        ...params.toQueryParameters(),
      },
    );

    final rawData = response.data;
    final rawMeta = response.extra['metadata'];

    final List<VocabularyListItem> items;
    if (rawData is List) {
      items = rawData
          .map((e) => VocabularyListItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      items = [];
    }

    final meta = rawMeta is Map<String, dynamic>
        ? PaginationMeta.fromJson(rawMeta)
        : PaginationMeta(total: items.length, page: 1, pageSize: 20, totalPages: 1);

    return PaginatedResponse(items: items, meta: meta);
  }
}
