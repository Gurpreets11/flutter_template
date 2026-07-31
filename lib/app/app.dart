import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../features/settings/presentation/providers/font_scale_controller.dart';
import '../features/settings/presentation/providers/theme_mode_controller.dart';
import '../theme/starter_theme.dart';
import 'app_providers.dart';
import 'router.dart';

/// The app's root widget. Wraps [MaterialApp.router] with
/// [AppThemeScope] so every shared widget in `core_package` can read
/// [starterThemeConfig] via `AppThemeScope.of(context)`, and wraps the
/// routed content with [AppConnectivityBanner] (offline indicator) and
/// a `MediaQuery` override (the user's chosen font scale).
class StarterApp extends ConsumerWidget {
  /// Creates a [StarterApp].
  const StarterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final connectivityService = ref.watch(connectivityServiceProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final fontScale = ref.watch(fontScaleControllerProvider);

    return AppThemeScope(
      config: starterThemeConfig,
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: starterThemeConfig.toThemeData(),
        darkTheme: starterThemeConfig.toThemeData(brightness: Brightness.dark),
        themeMode: themeMode,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(fontScale.scale)),
          child: AppConnectivityBanner(
            connectivityService: connectivityService,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
