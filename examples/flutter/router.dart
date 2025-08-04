import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//*  ROUTE CONSTANTS
abstract class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const profile = '/profile';
  static const settings = '/settings';
  static const productDetail = '/product/detail';
}

//*  ROUTER PROVIDER
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,

    // Global redirect for auth
    redirect: (context, state) async {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;

      if (!isAuthenticated && !isLoginRoute) return AppRoutes.login;

      if (isAuthenticated && isLoginRoute) return AppRoutes.home;

      return null;
    },

    routes: [
      // Auth route
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _slide(const LoginScreen()),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) => AppScaffold(body: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => _noTransition(const HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) =>
                _noTransition(const ProfileScreen()),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) =>
                _noTransition(const SettingsScreen()),
          ),
        ],
      ),

      // Detail route with parameter
      GoRoute(
        path: AppRoutes.productDetail,
        pageBuilder: (context, state) {
          final productId = state.queryParameters['id'] ?? '';
          return _slide(ProductDetailScreen(productId: productId));
        },
      ),
    ],
  );
});

//*  TRANSITION HELPERS
CustomTransitionPage _fade(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, _, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage _slide(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, _, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

NoTransitionPage _noTransition(Widget child) => NoTransitionPage(child: child);

//*  NAVIGATION EXTENSIONS
extension NavigationExtension on BuildContext {
  /// Navigates to the home screen.
  void goHome() => go(AppRoutes.home);

  /// Navigates to the login screen.
  void goToLogin() => go(AppRoutes.login);

  /// Navigates to the product screen.
  void goToProduct(String productId) {
    go('${AppRoutes.productDetail}?id=$productId');
  }
}
