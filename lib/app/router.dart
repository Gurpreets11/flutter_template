import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/auth/providers/auth_state.dart';
import '../features/auth/screens/change_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../shared/app_shell.dart';

/// Notifies [GoRouter] to re-run its `redirect` callback whenever auth
/// state changes (login/logout/session check completing) — without
/// this, the router would only re-evaluate on navigation events, so a
/// login succeeding wouldn't automatically move you off `/login`.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

/// The app's router. Depends on [authProvider] for its
/// redirect logic — see each `case` below for the routing rules.
final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final location = state.matchedLocation;
      final isSplash = location == '/splash';
      final isLoggingIn = location == '/login';

      return switch (authState.status) {
        // Still checking for a persisted session — stay on splash.
        AuthStatus.unknown => isSplash ? null : '/splash',
        // Signed in — bounce away from splash/login toward home.
        AuthStatus.authenticated => (isSplash || isLoggingIn) ? '/home' : null,
        // Not signed in — bounce everything except login toward login.
        AuthStatus.unauthenticated => isLoggingIn ? null : '/login',
      };
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final title = switch (state.matchedLocation) {
            '/profile' => 'Profile',
            _ => 'Home',
          };
          return AppShell(title: title, child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
