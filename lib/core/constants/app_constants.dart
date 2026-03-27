class AppConstants {
  const AppConstants._();

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // HSK levels
  static const int hskMinLevel = 1;
  static const int hskMaxLevel = 9;
  static const List<int> freeHskLevels = [1, 2, 3];

  // Cache TTL
  static const Duration cacheTtlShort = Duration(minutes: 5);
  static const Duration cacheTtlMedium = Duration(minutes: 30);
  static const Duration cacheTtlLong = Duration(hours: 2);

  // OCR
  static const int maxImageSizeBytes = 10 * 1024 * 1024; // 10MB
}
