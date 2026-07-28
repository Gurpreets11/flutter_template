import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/providers/auth_providers.dart';

/// Wraps every authenticated screen with a consistent [AppCommonBar]
/// and [AppNavigationDrawer]. New apps built from this template add
/// their own feature screens as additional [AppDrawerItem]s here.
///
/// ```dart
/// ShellRoute(
///   builder: (context, state, child) => AppShell(title: 'Home', child: child),
///   routes: [...],
/// )
/// ```
class AppShell extends ConsumerWidget {
  /// Creates an [AppShell].
  const AppShell({required this.title, required this.child, super.key});

  /// The current screen's title, shown in the [AppCommonBar].
  final String title;

  /// The routed screen content.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      appBar: AppCommonBar(title: title, showBackButton: false),
      drawer: AppNavigationDrawer(
        header: UserAccountsDrawerHeader(
          accountName: Text(authState.user?.name ?? ''),
          accountEmail: Text(authState.user?.email ?? ''),
        ),
        items: [
          AppDrawerItem(
            label: 'Home',
            icon: Icons.dashboard_outlined,
            isSelected: location == '/home',
            onTap: () {
              Navigator.of(context).pop();
              context.go('/home');
            },
          ),
          AppDrawerItem(
            label: 'Profile',
            icon: Icons.person_outline,
            isSelected: location == '/profile',
            onTap: () {
              Navigator.of(context).pop();
              context.go('/profile');
            },
          ),
        ],
        footerItems: [
          AppDrawerItem(
            label: 'Log out',
            icon: Icons.logout,
            onTap: () async {
              Navigator.of(context).pop();
              final confirmed = await AppDialogs.showConfirm(
                context,
                title: 'Log out?',
                message: 'You\'ll need to sign in again to continue.',
                confirmLabel: 'Log out',
                isDestructive: true,
              );
              if (confirmed) {
                await ref.read(authControllerProvider.notifier).logout();
              }
            },
          ),
        ],
      ),
      body: child,
    );
  }
}
