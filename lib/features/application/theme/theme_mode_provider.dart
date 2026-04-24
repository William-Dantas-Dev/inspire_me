import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../data/services/theme_preferences_service.dart';

final themePreferencesServiceProvider = Provider<ThemePreferencesService>((
  ref,
) {
  final prefs = ref.read(sharedPreferencesProvider);
  return ThemePreferencesService(prefs);
});

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final service = ref.read(themePreferencesServiceProvider);
    return service.loadThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;

    state = mode;

    final service = ref.read(themePreferencesServiceProvider);
    await service.saveThemeMode(mode);
  }

  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }

  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  Future<void> toggleTheme() async {
    switch (state) {
      case ThemeMode.system:
        await setThemeMode(ThemeMode.light);
        break;
      case ThemeMode.light:
        await setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        await setThemeMode(ThemeMode.light);
        break;
    }
  }
}
