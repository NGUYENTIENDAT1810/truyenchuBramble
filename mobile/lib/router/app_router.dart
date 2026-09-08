import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/bramble_bottom_bar.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/library/presentation/library_screen.dart';
import '../features/discover/presentation/discover_screen.dart';
import '../features/stats/presentation/stats_screen.dart';
import '../features/books/presentation/novel_detail_screen.dart';
import '../features/books/presentation/chapter_list_screen.dart';
import '../features/books/presentation/author_screen.dart';
import '../features/reader/presentation/reader_screen.dart';
import '../features/comments/presentation/comments_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/settings/presentation/appearance_screen.dart';
import '../core/theme/bramble_colors.dart';
import '../core/theme/bramble_typography.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRefresh = _AuthRouterRefresh(ref);
  ref.onDispose(authRefresh.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authRefresh,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isAuth = authState.status == AuthStatus.authenticated;
      final isInitializing = authState.status == AuthStatus.initializing;
      final location = state.matchedLocation;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/onboarding';

      if (isInitializing) {
        return location == '/splash' ? null : '/splash';
      }

      if (!isAuth && !isAuthRoute && location != '/splash') {
        return '/login';
      }

      if (isAuth && (location == '/login' || location == '/signup')) {
        return '/home';
      }

      if (location == '/splash') return isAuth ? '/home' : '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const _SplashScreen(),
      ),

      // Shell Route for 4 Bottom Bar Tabs
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          int currentIndex = 0;
          final loc = state.matchedLocation;
          if (loc.startsWith('/library')) currentIndex = 1;
          if (loc.startsWith('/discover')) currentIndex = 2;
          if (loc.startsWith('/stats')) currentIndex = 3;

          return Scaffold(
            body: Stack(
              children: [
                child,
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BrambleBottomBar(
                    currentIndex: currentIndex,
                    onTap: (index) {
                      switch (index) {
                        case 0:
                          context.go('/home');
                          break;
                        case 1:
                          context.go('/library');
                          break;
                        case 2:
                          context.go('/discover');
                          break;
                        case 3:
                          context.go('/stats');
                          break;
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/library',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LibraryScreen(),
            ),
          ),
          GoRoute(
            path: '/discover',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DiscoverScreen(),
            ),
          ),
          GoRoute(
            path: '/stats',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatsScreen(),
            ),
          ),
        ],
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Detail & Reader routes
      GoRoute(
        path: '/book/:id',
        builder: (context, state) => NovelDetailScreen(
          bookId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/book/:id/toc',
        builder: (context, state) => ChapterListScreen(
          bookId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/author/:id',
        builder: (context, state) => AuthorScreen(
          authorId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/reader/:id',
        builder: (context, state) => ReaderScreen(
          chapterId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/comments/:id',
        builder: (context, state) => CommentsScreen(
          chapterId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/appearance',
        builder: (context, state) => const AppearanceScreen(),
      ),
    ],
  );
});

class _AuthRouterRefresh extends ChangeNotifier {
  _AuthRouterRefresh(Ref ref) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.status != next.status) notifyListeners();
    });
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: BrambleColors.primaryOrange),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: BrambleTypography.bodyMedium(color: BrambleColors.creamSubdued),
            ),
          ],
        ),
      ),
    );
  }
}
