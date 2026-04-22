import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/preference_keys.dart';

class LocalePreferencesService {
  LocalePreferencesService(this._prefs);

  final SharedPreferences _prefs;

  Locale? loadLocale() {
    final storedValue = _prefs.getString(PreferenceKeys.localeCode);

    if (storedValue == null || storedValue.isEmpty) {
      return null;
    }

    switch (storedValue) {
      case 'pt':
        return const Locale('pt');
      case 'en':
        return const Locale('en');
      default:
        return null;
    }
  }

  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(
      PreferenceKeys.localeCode,
      locale.languageCode,
    );
  }

  Future<void> clearLocale() async {
    await _prefs.remove(PreferenceKeys.localeCode);
  }
}