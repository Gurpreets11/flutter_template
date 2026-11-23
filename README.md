# Flutter Template

A reusable Flutter starter application using a **simple Feature-First architecture**. It includes starter authentication, splash, home, profile, settings, theme preferences, and navigation, integrated with [`core_package`](https://github.com/Gurpreets11/core_package).

## Technology stack

- Flutter / Dart
- Riverpod for state management and dependency providers
- GoRouter for navigation and authentication redirects
- `core_package` for shared infrastructure, secure storage, networking utilities, common widgets, validators, theme contracts, and app services

## Architecture

```text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── app_providers.dart
│   ├── router.dart
│   ├── biometric_lock_gate.dart
│   └── update_required_gate.dart
├── core/
│   └── constants/
├── features/
│   ├── auth/
│   │   ├── models/
│   │   ├── services/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── home/
│   │   └── screens/
│   ├── profile/
│   │   └── screens/
│   └── settings/
│       ├── services/
│       ├── providers/
│       └── screens/
├── shared/
│   └── app_shell.dart
└── theme/
    └── app_theme.dart
```

### Folder responsibilities

| Folder | Responsibility |
|---|---|
| `app/` | App bootstrap, app-wide providers, routing, lifecycle gates |
| `core/` | App-wide constants and infrastructure that is not specific to one feature |
| `features/<name>/models/` | Data models owned by a feature |
| `features/<name>/services/` | Feature operations and data access |
| `features/<name>/providers/` | Riverpod state and dependency providers |
| `features/<name>/screens/` | Route-level UI screens |
| `features/<name>/widgets/` | Widgets used only by that feature |
| `shared/` | Reusable UI shared by multiple features |
| `theme/` | App theme configuration |

### Typical feature flow

```text
Screen → Riverpod Provider/Controller → Feature Service → core_package / API / Storage
```

Keep the structure lightweight. Add a repository, use case, or additional abstraction only when a feature's complexity or testing needs justify it. Avoid putting feature-specific behavior in `core/`.

## Included features

- **Authentication:** demo login, logout, change password, and persisted demo session.
- **Splash and routing:** GoRouter redirects based on authentication state.
- **Home and profile:** starter screens to replace with application-specific content.
- **Settings:** theme mode, font scale, notification preference, support/about information, and logout.
- **App shell:** common navigation shell for authenticated screens.
- **App gates:** optional biometric lock, idle timeout, connectivity banner, and force-update gate, controlled by feature flags where configured.
- **Theme:** central theme configuration in `lib/theme/app_theme.dart`.

## Important demo limitations

- `AuthService` is a demo implementation. It accepts any email string with a password of at least eight characters and stores a demo token. It does not authenticate against a backend.
- Change-password currently validates the new password length and returns demo success; it does not call a server.
- The update-check service is a demo implementation and reports the app as up to date.
- Notification settings store the user's preference; they do not register push notifications with FCM or another provider.

Replace these demo services with real backend/provider integrations before production release.

## Getting started

1. Use this repository as a GitHub template or clone it.
2. Change the package `name` in `pubspec.yaml` and update package imports if you rename it.
3. Update Android application ID, iOS bundle identifier, and display name for your app.
4. Keep `core_package` pinned to a tagged release rather than an unpinned branch.
5. Customize `lib/theme/app_theme.dart` and `lib/core/constants/`.
6. Add new application modules under `lib/features/<feature_name>/`.

Run the app:

```bash
flutter pub get
flutter run
```

## Testing and quality checks

Run:

```bash
dart format lib test
flutter analyze
flutter test
```

Authentication tests cover controller state transitions and the demo service's session persistence/validation using an in-memory fake secure-storage implementation. Tests do not require a real secure-storage platform channel.

## Versioning

This architecture migration is released as **v2.0.0**. Keep the package version and Git tag aligned when creating the release.
