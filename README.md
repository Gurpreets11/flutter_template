# flutter_template

## core_package

A reusable Flutter foundation for building Clean Architecture apps quickly:
networking, error handling, logging, validation, a configurable theming
contract, and base architecture classes — with zero business logic baked in,
so it's safe to reuse across any number of apps.

This package is deliberately unopinionated about *what* your app does — it
only standardizes *how* the plumbing works, so every app built on it shares
the same network layer, error handling, and design-token-driven theming.

## Status

🚧 Early development (`0.1.0`) — API may still change before a `1.0.0`
release. Currently distributed via GitHub; will move to
[pub.dev](https://pub.dev) once the API is stable.

## Install

```yaml
dependencies:
  core_package:
    git:
      url: https://github.com/your-org/core-package.git
      ref: main
```

## What's included (Phase 1)

- **Networking** — `ApiClient`, a Dio wrapper returning a `Result<T>` so
  callers never need try/catch; `AuthInterceptor` and `LoggingInterceptor`.
- **Errors** — an `AppException` hierarchy (data layer) mapped via
  `ExceptionMapper` to a `Failure` hierarchy (domain/presentation layer).
- **Logging** — `AppLogger`, silent in release builds.
- **Validation** — composable `Validators` (email, phone, password,
  required, min/max length, matches).
- **Theming** — `AppThemeConfig`, a design-token contract consumed by
  shared widgets (added in Phase 2) so each app can be branded differently
  without touching this package's code. `AppThemeScope` exposes it via
  `InheritedWidget`.
- **Base classes** — `UseCase<Type, Params>` and a `Repository` marker
  interface for Clean Architecture layering.

## Quick start

```dart
import 'package:core_package/core_package.dart';
import 'package:dio/dio.dart';

// 1. Configure Dio for this app's environment.
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'))
  ..interceptors.addAll([
    AuthInterceptor(
      getToken: () async => tokenStorage.readToken(),
      onUnauthorized: () async => authController.logout(),
    ),
    LoggingInterceptor(),
  ]);

final apiClient = ApiClient(dio);

// 2. Wrap the app root with this app's brand theme.
void main() {
  final themeConfig = AppThemeConfig(
    primary: const Color(0xFF1A237E),
    secondary: const Color(0xFF00897B),
    background: const Color(0xFFF5F5F5),
    surface: Colors.white,
    error: const Color(0xFFD32F2F),
  );

  runApp(
    AppThemeScope(
      config: themeConfig,
      child: MaterialApp(
        theme: themeConfig.toThemeData(),
        home: const HomeScreen(),
      ),
    ),
  );
}
```

## Roadmap

See the project's architecture guide for the full phased plan (common
widgets, storage, connectivity, and the companion starter template repo).

## Contributing

Issues and PRs welcome — see `CONTRIBUTING.md` (coming soon).

## License

MIT — see `LICENSE`.

 