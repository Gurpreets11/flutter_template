import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_providers.dart';

/// The profile screen — shows the current user's details with actions
/// to change their password or log out. New apps built from this
/// template extend this with real profile fields (avatar upload,
/// organization, role, etc.) as the backend supports them.
class ProfileScreen extends ConsumerWidget {
  /// Creates a [ProfileScreen].
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = AppThemeScope.of(context);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    if (user == null) {
      return const AppEmptyState(
        title: 'No profile to show',
        message: 'Sign in to view your profile.',
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(config.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: config.primary,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: config.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: config.spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: config.spacing.xs / 2),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: config.spacing.md),
          AppButton(
            label: 'Change password',
            variant: AppButtonVariant.outlined,
            icon: Icons.lock_reset_outlined,
            onPressed: () => context.push('/change-password'),
          ),
          SizedBox(height: config.spacing.sm),
          AppButton(
            label: 'Log out',
            variant: AppButtonVariant.text,
            icon: Icons.logout,
            isLoading: authState.isLoading,
            onPressed: () async {
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
    );
  }
}
