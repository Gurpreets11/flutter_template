import 'package:core_package/core_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_mode_controller.dart'
    show appPreferencesServiceProvider;

/// Manages whether push notifications are enabled, persisting the
/// choice via [AppPreferencesService].
///
/// This only tracks the user's *preference* — actually registering
/// for/unregistering from push notifications with a provider (FCM,
/// etc.) is deliberately out of scope for this starter, since it pulls
/// in a specific backend choice. Wire that up alongside a real
/// `AuthRepositoryImpl` once this app has one.
class NotificationSettingsController extends StateNotifier<bool> {
  /// Creates a [NotificationSettingsController], loading any previously
  /// persisted choice immediately. Defaults to `true` (enabled) until
  /// loaded.
  NotificationSettingsController({required AppPreferencesService preferences})
      : _preferences = preferences,
        super(true) {
    _loadPersisted();
  }

  final AppPreferencesService _preferences;

  static const _key = 'notifications_enabled';

  Future<void> _loadPersisted() async {
    final stored = await _preferences.getBool(key: _key);
    if (stored != null) state = stored;
  }

  /// Updates the preference and persists it.
  Future<void> setEnabled(bool value) async {
    state = value;
    await _preferences.setBool(key: _key, value: value);
  }
}

/// The current notifications-enabled preference.
final notificationSettingsControllerProvider =
    StateNotifierProvider<NotificationSettingsController, bool>((ref) {
  return NotificationSettingsController(
    preferences: ref.watch(appPreferencesServiceProvider),
  );
});
