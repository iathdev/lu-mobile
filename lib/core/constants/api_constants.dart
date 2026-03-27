class ApiConstants {
  const ApiConstants._();

  // Base URL — override via environment or flutter_dotenv
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://172.16.202.162:8001',
  );

  // Auth
  static const String me = '/api/v1/auth/me';

  // Vocabulary
  static const String vocabularies = '/api/v1/vocabularies';
  static String vocabulary(String id) => '/api/v1/vocabularies/$id';
  static String vocabularyDetail(String id) => '/api/v1/vocabularies/$id/detail';
  static String hskLevel(int level) => '/api/v1/vocabularies/hsk/$level';
  static String topicVocabularies(String slug) =>
      '/api/v1/vocabularies/topic/$slug';
  static const String searchVocabularies = '/api/v1/vocabularies/search';
  static const String ocrScan = '/api/vocabularies/ocr-scan';

  // Topics
  static const String topics = '/api/v1/topics';

  // Folders
  static const String folders = '/api/v1/folders';
  static String folder(String id) => '/api/v1/folders/$id';
  static String folderVocabularies(String id) =>
      '/api/v1/folders/$id/vocabularies';
  static String folderVocabulary(String folderId, String vocabId) =>
      '/api/v1/folders/$folderId/vocabularies/$vocabId';

  // Entitlement
  static const String entitlements = '/api/v1/entitlements/me';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 30);
}
