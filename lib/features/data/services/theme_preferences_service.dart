import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/preference_keys.dart';

class ThemePreferencesService {
  ThemePreferencesService(this._prefs);

  final SharedPreferences _prefs;

  ThemeMode loadThemeMode() {
    final storedValue = _prefs.getString(PreferenceKeys.themeMode);

    switch (storedValue) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(PreferenceKeys.themeMode, _mapThemeModeToString(mode));
  }

  String _mapThemeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}