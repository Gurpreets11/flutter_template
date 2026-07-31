import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/font_scale_controller.dart';
import '../providers/notification_settings_controller.dart';
import '../providers/theme_mode_controller.dart';

/// The Settings screen — the single home for account actions and app
/// preferences: profile, change password, appearance (theme + font
/// size), notifications, support, and logout.
///
/// Reached via [AppCommonBar]'s overflow menu (see `AppShell`), not a
/// bottom-nav tab — it's a secondary destination, not a primary one.
class SettingsScreen extends ConsumerWidget {
  /// Creates a [SettingsScreen].
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = AppThemeScope.of(context);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final themeMode = ref.watch(themeModeControllerProvider);
    final fontScale = ref.watch(fontScaleControllerProvider);
    final notificationsEnabled = ref.watch(
      notificationSettingsControllerProvider,
    );

    return Scaffold(
      appBar: const AppCommonBar(title: 'Settings'),
      body: ListView(
        padding: EdgeInsets.all(config.spacing.md),
        children: [
          if (user != null)
            AppCard(
              onTap: () => context.go('/profile'),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: config.primary,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: TextStyle(color: config.onPrimary),
                    ),
                  ),
                  SizedBox(width: config.spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          SizedBox(height: config.spacing.md),
          const _SectionLabel('Account'),
          AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_reset_outlined),
              title: const Text('Change password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/change-password'),
            ),
          ),
          SizedBox(height: config.spacing.md),
          const _SectionLabel('Appearance'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Theme', style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: config.spacing.sm),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (selection) {
                    ref
                        .read(themeModeControllerProvider.notifier)
                        .setThemeMode(selection.first);
                  },
                ),
                SizedBox(height: config.spacing.md),
                Text(
                  'Font size',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: config.spacing.sm),
                SegmentedButton<AppFontScale>(
                  segments: [
                    for (final option in AppFontScale.values)
                      ButtonSegment(value: option, label: Text(option.label)),
                  ],
                  selected: {fontScale},
                  onSelectionChanged: (selection) {
                    ref
                        .read(fontScaleControllerProvider.notifier)
                        .setScale(selection.first);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: config.spacing.md),
          const _SectionLabel('Notifications'),
          AppCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Push notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                ref
                    .read(notificationSettingsControllerProvider.notifier)
                    .setEnabled(value);
              },
            ),
          ),
          SizedBox(height: config.spacing.md),
          const _SectionLabel('Support'),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.mail_outline),
                  title: const Text('Contact us'),
                  subtitle: const Text(AppConstants.supportEmail),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => AppDialogs.showAlert(
                    context,
                    title: 'Contact us',
                    message: 'Reach us at ${AppConstants.supportEmail} for '
                        'help or feedback.',
                  ),
                ),
                const Divider(height: 1),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data?.version;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.info_outline),
                      title: const Text('About us'),
                      subtitle: Text(
                        version != null
                            ? '${AppConstants.appName} v$version'
                            : AppConstants.appName,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => AppDialogs.showAlert(
                        context,
                        title: 'About ${AppConstants.appName}',
                        message: version != null
                            ? 'Version $version'
                            : 'Version information unavailable.',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: config.spacing.md),
          AppButton(
            label: 'Log out',
            variant: AppButtonVariant.outlined,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: primaryColor),
      ),
    );
  }
}
