import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/providers/auth_providers.dart';

/// Wraps every authenticated screen with a consistent [AppCommonBar]
/// (title, 3-dot overflow menu), [AppBottomNavBar] (primary Home/
/// Profile switching), and [AppNavigationDrawer] (hamburger-triggered,
/// for the same Settings/Log out actions as the overflow menu — some
/// users reach for the drawer, others for the overflow menu, so both
/// are wired to the same actions rather than splitting functionality
/// across them).
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

  static const _tabRoutes = ['/home', '/profile'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final location = GoRouterState.of(context).matchedLocation;
    final currentTabIndex = _tabRoutes.indexOf(location).clamp(0, 1);

    Future<void> handleLogout() async {
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
    }

    return Scaffold(
      appBar: AppCommonBar(
        title: title,
        overflowMenuItems: [
          AppOverflowMenuItem(
            label: 'Settings',
            icon: Icons.settings_outlined,
            onTap: () => context.push('/settings'),
          ),
          AppOverflowMenuItem(
            label: 'Log out',
            icon: Icons.logout,
            isDestructive: true,
            onTap: handleLogout,
          ),
        ],
      ),
      drawer: AppNavigationDrawer(
        header: UserAccountsDrawerHeader(
          accountName: Text(authState.user?.name ?? ''),
          accountEmail: Text(authState.user?.email ?? ''),
        ),
        items: [
          AppDrawerItem(
            label: 'Settings',
            icon: Icons.settings_outlined,
            onTap: () {
              Navigator.of(context).pop();
              context.push('/settings');
            },
          ),
        ],
        footerItems: [
          AppDrawerItem(
            label: 'Log out',
            icon: Icons.logout,
            onTap: () {
              Navigator.of(context).pop();
              handleLogout();
            },
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentTabIndex,
        onTap: (index) => context.go(_tabRoutes[index]),
        items: const [
          AppBottomNavItem(
            label: 'Home',
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
          ),
          AppBottomNavItem(
            label: 'Profile',
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
          ),
        ],
      ),
      body: child,
    );
  }
}
