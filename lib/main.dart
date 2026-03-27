import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_mobile/app.dart';
import 'package:lu_mobile/core/i18n/locale_provider.dart';
import 'package:lu_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences before app starts
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const _AppLoader(),
    ),
  );
}

/// Loads auth state before rendering the app.
class _AppLoader extends ConsumerStatefulWidget {
  const _AppLoader();

  @override
  ConsumerState<_AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends ConsumerState<_AppLoader> {
  @override
  void initState() {
    super.initState();
    // Check if user has a stored token
    ref.read(authProvider.notifier).checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Show splash while checking auth
    if (authState.isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return const App();
  }
}
