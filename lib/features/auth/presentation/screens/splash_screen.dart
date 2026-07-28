import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';

/// The initial screen shown while the router's redirect logic
/// determines whether a session exists. This screen itself doesn't
/// navigate anywhere — see `app/router.dart`'s `redirect` callback,
/// which watches `authControllerProvider` and routes to `/login` or
/// `/home` once the status is known.
class SplashScreen extends StatelessWidget {
  /// Creates a [SplashScreen].
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return Scaffold(
      backgroundColor: config.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.apps, size: 64, color: config.onPrimary),
            SizedBox(height: config.spacing.md),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(config.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
