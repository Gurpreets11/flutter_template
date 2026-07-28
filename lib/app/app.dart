import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/starter_theme.dart';
import 'router.dart';

/// The app's root widget. Wraps [MaterialApp.router] with
/// [AppThemeScope] so every shared widget in `core_package` can read
/// [starterThemeConfig] via `AppThemeScope.of(context)`.
class StarterApp extends ConsumerWidget {
  /// Creates a [StarterApp].
  const StarterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return AppThemeScope(
      config: starterThemeConfig,
      child: MaterialApp.router(
        title: 'Flutter Starter',
        debugShowCheckedModeBanner: false,
        theme: starterThemeConfig.toThemeData(),
        darkTheme: starterThemeConfig.toThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}
