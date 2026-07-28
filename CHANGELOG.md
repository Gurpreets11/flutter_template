# Changelog

## 0.2.0

- **Refactor**: `AuthLocalDataSource` now depends on `core_package`'s `SecureStorageService` instead of `flutter_secure_storage` directly — closes a testing gap, since it can now be tested with a fake in-memory storage instead of needing a mocked platform channel.
- **Connectivity**: wired `AppConnectivityBanner` (from `core_package`) into the app root via `MaterialApp.router`'s `builder`, so every screen shows a consistent offline indicator.
- Added `app_providers.dart` for the app-level `connectivityServiceProvider`.
- Removed the now-redundant direct `flutter_secure_storage` dependency.
- Bumped `core_package` dependency to `v0.3.0`.
- **Testing**: added `AuthLocalDataSource` tests using a fake `SecureStorageService`.

## 0.1.0

Initial scaffold — splash, login, home, profile, and change-password
screens wired to `core_package` (`v0.2.1`):

- `lib/app/` — `main.dart`, `StarterApp` (theme + router wiring), `router.dart`
  (GoRouter with auth-driven redirects reacting to auth state)
- `lib/theme/starter_theme.dart` — the single file to edit to re-brand a new app
- `lib/shell/app_shell.dart` — common app bar + navigation drawer wrapping
  every authenticated screen
- `lib/features/auth/` — full Clean Architecture slice (domain / data /
  presentation): `AuthUser`, `AuthRepository`, a demo `AuthRepositoryImpl`,
  `AuthLocalDataSource`, 3 use cases, `AuthController` (Riverpod
  `StateNotifier`), and splash/login/change-password screens
- `lib/features/home/`, `lib/features/profile/` — starter screens
- **Testing**: `AuthController` covered with a mocked `AuthRepository`
