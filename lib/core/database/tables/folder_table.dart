import 'package:drift/drift.dart';

/// Local cache of user folders.
class CachedFolders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Junction table: folder <-> vocabulary (cached locally).
class CachedFolderVocabularies extends Table {
  TextColumn get folderId => text()();
  TextColumn get vocabularyId => text()();

  @override
  Set<Column> get primaryKey => {folderId, vocabularyId};
}
