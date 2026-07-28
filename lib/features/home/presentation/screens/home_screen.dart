import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';

/// The home screen — the first screen shown after login. New apps
/// built from this template replace this with their real dashboard
/// (e.g. a leads list, an order summary), using the same [AppCard],
/// [AppEmptyState], etc. from `core_package`.
class HomeScreen extends ConsumerWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = AppThemeScope.of(context);
    final authState = ref.watch(authControllerProvider);

    return Padding(
      padding: EdgeInsets.all(config.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${authState.user?.name ?? ''}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: config.spacing.md),
          AppCard(
            child: Row(
              children: [
                Icon(Icons.info_outline, color: config.primary),
                SizedBox(width: config.spacing.sm),
                const Expanded(
                  child: Text(
                    'This is the starter home screen. Replace this card '
                    'with your app\'s real dashboard content.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
