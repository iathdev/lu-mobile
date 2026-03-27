import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_mobile/core/i18n/locale_provider.dart';
import 'package:lu_mobile/core/network/api_client.dart';
import 'package:lu_mobile/features/auth/presentation/providers/auth_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final locale = ref.watch(localeProvider);
  return ApiClient(
    storage: storage,
    localeGetter: () => locale,
  );
});
