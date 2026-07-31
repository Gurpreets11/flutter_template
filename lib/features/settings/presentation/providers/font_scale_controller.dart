import 'package:core_package/core_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_mode_controller.dart'
    show appPreferencesServiceProvider;

/// A curated set of font scale options — deliberately a small enum
/// rather than a free-form slider, so every app screen only ever needs
/// to handle a few known scales.
enum AppFontScale {
  /// 85% of the base text size.
  small(0.85, 'Small'),

  /// 100% — the default.
  medium(1.0, 'Medium'),

  /// 115% of the base text size.
  large(1.15, 'Large');

  const AppFontScale(this.scale, this.label);

  /// The multiplier applied via `TextScaler.linear`.
  final double scale;

  /// The display label shown in settings.
  final String label;

  /// Resolves the closest [AppFontScale] to a persisted raw [value],
  /// falling back to [medium] if it doesn't match any known option.
  static AppFontScale fromScale(double? value) {
    return AppFontScale.values.firstWhere(
      (option) => option.scale == value,
      orElse: () => AppFontScale.medium,
    );
  }
}

/// Manages the user's chosen text scale, persisting it via
/// [AppPreferencesService]. [StarterApp] applies the resulting
/// [AppFontScale.scale] app-wide via a `MediaQuery` override.
class FontScaleController extends StateNotifier<AppFontScale> {
  /// Creates a [FontScaleController], loading any previously persisted
  /// choice immediately.
  FontScaleController({required AppPreferencesService preferences})
      : _preferences = preferences,
        super(AppFontScale.medium) {
    _loadPersisted();
  }

  final AppPreferencesService _preferences;

  static const _key = 'font_scale';

  Future<void> _loadPersisted() async {
    final stored = await _preferences.getDouble(key: _key);
    state = AppFontScale.fromScale(stored);
  }

  /// Updates the font scale and persists it.
  Future<void> setScale(AppFontScale option) async {
    state = option;
    await _preferences.setDouble(key: _key, value: option.scale);
  }
}

/// The current [AppFontScale].
final fontScaleControllerProvider =
    StateNotifierProvider<FontScaleController, AppFontScale>((ref) {
  return FontScaleController(
    preferences: ref.watch(appPreferencesServiceProvider),
  );
});
