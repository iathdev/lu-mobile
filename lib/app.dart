import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_mobile/core/i18n/locale_provider.dart';
import 'package:lu_mobile/core/router/app_router.dart';
import 'package:lu_mobile/core/theme/app_theme.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final _router = createRouter(ref);

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Prep Chinese Vocab',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,

      // Locale
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Router
      routerConfig: _router,
    );
  }
}
