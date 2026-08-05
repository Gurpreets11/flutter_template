# Changelog

## 0.6.0

- **New**: `featureFlagsProvider` (`lib/app/app_providers.dart`) — this app's `AppFeatureFlags` instance. Idle timeout and force-update check are on by default (to demo the wiring); biometric lock is off by default (needs biometrics enrolled on the test device to demo cleanly).
- **New**: `AppIdleTimeoutGuard` wired into `StarterApp` — logs out after 15 minutes of no interaction when `enableIdleTimeout` is on.
- **New**: `BiometricLockGate` (`lib/app/`) — shows a lock screen on app resume from background when `enableBiometricLock` is on, using `core_package`'s `BiometricLockService`.
- **New**: `UpdateRequiredGate` (`lib/app/`) + `DemoUpdateCheckServiceImpl` (`lib/features/settings/data/`) — checks for a required update on launch when `enableForceUpdateCheck` is on. The demo implementation always reports "up to date"; replace it once a real backend/remote-config source exists.
- Bumped `core_package` dependency to `v0.7.0`.

## 0.5.0

- **New**: `ThemeModeController` — persists the user's light/dark/system choice via `core_package`'s `AppPreferencesService`. Wired into `StarterApp`'s `themeMode`.
- **New**: `FontScaleController` + `AppFontScale` (Small/Medium/Large curated enum, not a free-form slider) — persists the user's text-size choice, applied app-wide via a `MediaQuery` override in `StarterApp`.
- **New**: `NotificationSettingsController` — persists the notifications-enabled preference. Deliberately tracks the *preference* only; actually registering for push notifications with a provider (FCM, etc.) is out of scope here, same honest-scope pattern as `AuthRepositoryImpl`.
- **New**: `lib/constants/` — `AppConstants` (app name, support email, policy URLs, min password length, default page size) and `ApiConstants` (base URL, timeouts, endpoint paths — placeholders until real API integration).
- **New**: the real **Settings screen** (`/settings`) — Account (view profile, change password), Appearance (theme mode + font size), Notifications toggle, Support (contact us, about us with app version via `package_info_plus`), and Log out. This is now the single home for all of the above; the Profile screen no longer carries a temporary Appearance control.
- **`AppShell`**: `AppCommonBar`'s overflow menu (3-dot) and the navigation drawer are now both wired to the same two actions — Settings and Log out — rather than splitting functionality across them; the drawer's old separate "Change password" item was folded into Settings.
- Bumped `core_package` dependency to the tagged `v0.6.0` (component-level card/field theming, responsive breakpoint utilities — not otherwise used by this app yet, but available).

## 0.4.0

- **Login screen**: primary "Sign in" CTA now uses `AppButton`'s gradient variant (from `core_package` `v0.5.0`) as a working example.
- **Home screen**: added a "Sort by" control using `AppDropdownTrigger` paired with `AppDialogs.showActionSheet`, sorting the demo activity list newest/oldest-first.
- Bumped `core_package` dependency to `v0.5.0`.

## 0.3.0

- **Home screen**: now a real, working demo combining `AppSearchField` and `AppPaginatedListView` (from `core_package` `v0.4.0`) against an in-memory dataset — pull-to-refresh-free infinite scroll, debounced search, empty state on no matches. Replace `_allItems`/`_loadMore` with a real repository call in an app built from this template.
- **Navigation**: `AppShell` now uses `AppBottomNavBar` for primary Home/Profile switching; the drawer is scoped to secondary actions (Change password, Log out) — a common hybrid pattern.
- **Feedback**: login and change-password screens now use `AppSnackbar` (success/error) instead of raw `ScaffoldMessenger` calls.
- Bumped `core_package` dependency to `v0.4.0`.

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