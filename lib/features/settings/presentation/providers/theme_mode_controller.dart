import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The preferences service backing settings persistence. Kept in the
/// `settings` feature (rather than `app/`) since it's specifically a
/// settings-storage concern, unlike `connectivityServiceProvider`
/// which is genuinely app-wide.
final appPreferencesServiceProvider = Provider<AppPreferencesService>((ref) {
  return AppPreferencesServiceImpl();
});

/// Manages the app's [ThemeMode], persisting the user's choice via
/// [AppPreferencesService] so it survives app restarts.
class ThemeModeController extends StateNotifier<ThemeMode> {
  /// Creates a [ThemeModeController] backed by [_preferences], loading
  /// any previously persisted choice immediately.
  ThemeModeController({required AppPreferencesService preferences})
      : _preferences = preferences,
        super(ThemeMode.system) {
    _loadPersisted();
  }

  final AppPreferencesService _preferences;

  static const _key = 'theme_mode';

  Future<void> _loadPersisted() async {
    final stored = await _preferences.getString(key: _key);
    state = _fromStoredValue(stored);
  }

  /// Updates the theme mode and persists the choice.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _preferences.setString(key: _key, value: mode.name);
  }

  ThemeMode _fromStoredValue(String? value) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}

/// The current [ThemeMode], read by [StarterApp] to drive
/// `MaterialApp.themeMode`.
final themeModeControllerProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  return ThemeModeController(
    preferences: ref.watch(appPreferencesServiceProvider),
  );
});
