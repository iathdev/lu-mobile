/// All route path constants — single source of truth.
class RoutePaths {
  const RoutePaths._();

  // Auth
  static const String login = '/login';
  static const String onboarding = '/onboarding';

  // Shell (bottom nav tabs)
  static const String home = '/home';
  static const String search = '/search';
  static const String scan = '/scan';
  static const String folders = '/folders';
  static const String profile = '/profile';

  // Vocabulary
  static const String hskLevel = '/hsk/:level';
  static const String topicVocabularies = '/topic/:slug';
  static const String vocabularyDetail = '/vocabulary/:id';
  static const String vocabularyCreate = '/vocabulary/create';
  static const String vocabularyEdit = '/vocabulary/:id/edit';

  // Folders
  static const String folderDetail = '/folders/:id';
  static const String folderCreate = '/folders/create';

  // OCR
  static const String scanPreview = '/scan/preview';
  static const String scanConfirm = '/scan/confirm';

  // Entitlement
  static const String upgrade = '/upgrade';

  // Helpers for parameterized paths
  static String hskLevelPath(int level) => '/hsk/$level';
  static String topicPath(String slug) => '/topic/$slug';
  static String vocabularyDetailPath(String id) => '/vocabulary/$id';
  static String vocabularyEditPath(String id) => '/vocabulary/$id/edit';
  static String folderDetailPath(String id) => '/folders/$id';
}
