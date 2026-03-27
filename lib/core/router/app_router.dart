import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_mobile/core/router/route_paths.dart';
import 'package:lu_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:lu_mobile/features/auth/presentation/pages/onboarding_page.dart';
import 'package:lu_mobile/features/auth/presentation/pages/profile_page.dart';
import 'package:lu_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:lu_mobile/features/entitlement/presentation/pages/upgrade_page.dart';
import 'package:lu_mobile/features/folder/presentation/pages/folder_detail_page.dart';
import 'package:lu_mobile/features/folder/presentation/pages/folder_form_page.dart';
import 'package:lu_mobile/features/folder/presentation/pages/folder_list_page.dart';
import 'package:lu_mobile/features/ocr/presentation/pages/ocr_camera_page.dart';
import 'package:lu_mobile/features/vocabulary/presentation/pages/hsk_level_page.dart';
import 'package:lu_mobile/features/vocabulary/presentation/pages/vocabulary_detail_page.dart';
import 'package:lu_mobile/features/vocabulary/presentation/pages/vocabulary_form_page.dart';
import 'package:lu_mobile/features/vocabulary/presentation/pages/vocabulary_list_page.dart';
import 'package:lu_mobile/features/vocabulary/presentation/pages/vocabulary_search_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.home,
    // TODO: Re-enable auth guard when login flow is implemented
    // redirect: (context, state) {
    //   final authState = ref.read(authProvider);
    //   final isLoggedIn = authState.isAuthenticated;
    //   final isOnLoginPage = state.matchedLocation == RoutePaths.login;
    //   if (!isLoggedIn && !isOnLoginPage) return RoutePaths.login;
    //   if (isLoggedIn && isOnLoginPage) return RoutePaths.home;
    //   return null;
    // },
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithBottomNav(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HskLevelPage(),
            ),
          ),
          GoRoute(
            path: RoutePaths.search,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: VocabularySearchPage(),
            ),
          ),
          GoRoute(
            path: RoutePaths.scan,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: OcrCameraPage(),
            ),
          ),
          GoRoute(
            path: RoutePaths.folders,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FolderListPage(),
            ),
          ),
          GoRoute(
            path: RoutePaths.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),

      // Detail routes (outside shell — full screen)
      GoRoute(
        path: RoutePaths.hskLevel,
        builder: (context, state) {
          final level = int.parse(state.pathParameters['level']!);
          return VocabularyListPage(hskLevel: level);
        },
      ),
      GoRoute(
        path: RoutePaths.topicVocabularies,
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return VocabularyListPage(topicSlug: slug);
        },
      ),
      GoRoute(
        path: RoutePaths.vocabularyDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return VocabularyDetailPage(id: id);
        },
      ),
      GoRoute(
        path: RoutePaths.vocabularyCreate,
        builder: (context, state) => const VocabularyFormPage(),
      ),
      GoRoute(
        path: RoutePaths.vocabularyEdit,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return VocabularyFormPage(editId: id);
        },
      ),
      GoRoute(
        path: RoutePaths.folderDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return FolderDetailPage(id: id);
        },
      ),
      GoRoute(
        path: RoutePaths.folderCreate,
        builder: (context, state) => const FolderFormPage(),
      ),
      // OCR preview/confirm use Navigator.push (need to pass result object)
      // so they are not registered as GoRouter paths.
      GoRoute(
        path: RoutePaths.upgrade,
        builder: (context, state) => const UpgradePage(),
      ),
    ],
  );
}

/// Shell widget with bottom navigation bar.
class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNav({super.key, required this.child});

  static const _tabs = [
    RoutePaths.home,
    RoutePaths.search,
    RoutePaths.scan,
    RoutePaths.folders,
    RoutePaths.profile,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _tabs.indexOf(location);
    return index >= 0 ? index : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(context),
        onTap: (index) => context.go(_tabs[index]),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'HSK',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Folders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
