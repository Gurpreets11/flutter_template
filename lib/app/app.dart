import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/presentation/provider/theme_mode_controller.dart';
import '../theme/starter_theme.dart';
import 'app_providers.dart';
import 'router.dart';

/// The app's root widget. Wraps [MaterialApp.router] with
/// [AppThemeScope] so every shared widget in `core_package` can read
/// [starterThemeConfig] via `AppThemeScope.of(context)`, and wraps the
/// routed content with [AppConnectivityBanner] so every screen shows a
/// consistent offline indicator.
class StarterApp extends ConsumerWidget {
  /// Creates a [StarterApp].
  const StarterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final connectivityService = ref.watch(connectivityServiceProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    return AppThemeScope(
      config: starterThemeConfig,
      child: MaterialApp.router(
        title: 'Flutter Starter',
        debugShowCheckedModeBanner: false,
        theme: starterThemeConfig.toThemeData(),
        darkTheme: starterThemeConfig.toThemeData(brightness: Brightness.dark),
        themeMode: themeMode,
        routerConfig: router,
        builder: (context, child) => AppConnectivityBanner(
          connectivityService: connectivityService,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
