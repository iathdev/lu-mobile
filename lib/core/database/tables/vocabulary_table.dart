import 'package:drift/drift.dart';

/// Local cache of vocabulary data from the API.
/// Mirrors the Go backend's VocabularyResponse fields.
class CachedVocabularies extends Table {
  TextColumn get id => text()();
  TextColumn get hanzi => text()();
  TextColumn get pinyin => text().nullable()();
  TextColumn get meaningVi => text().nullable()();
  TextColumn get meaningEn => text().nullable()();
  IntColumn get hskLevel => integer().nullable()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get examples => text().nullable()(); // JSON string
  TextColumn get radicals => text().nullable()(); // JSON array string
  IntColumn get strokeCount => integer().nullable()();
  TextColumn get strokeDataUrl => text().nullable()();
  BoolColumn get recognitionOnly => boolean().withDefault(const Constant(false))();
  IntColumn get frequencyRank => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cache metadata — tracks when each cache key was last refreshed.
class CacheMeta extends Table {
  TextColumn get cacheKey => text()(); // e.g., "hsk_3_page_1", "vocab_detail_<id>"
  DateTimeColumn get lastFetchedAt => dateTime()();
  IntColumn get totalItems => integer().nullable()();

  @override
  Set<Column> get primaryKey => {cacheKey};
}
