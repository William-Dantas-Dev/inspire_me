import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/preference_keys.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import 'app_startup_state.dart';

class AppStartupNotifier extends Notifier<AppStartupState> {
  @override
  AppStartupState build() {
    return const AppStartupState.idle();
  }

  Future<void> initialize() async {
    try {
      state = const AppStartupState.loading();

      final prefs = ref.read(sharedPreferencesProvider);

      final savedThemeMode = prefs.getString(PreferenceKeys.themeMode);
      final savedLocaleCode = prefs.getString(PreferenceKeys.localeCode);

      if (savedThemeMode == null || savedThemeMode.isEmpty) {
        await prefs.setString(PreferenceKeys.themeMode, 'system');
      }

      if (savedLocaleCode == null || savedLocaleCode.isEmpty) {
        await prefs.setString(PreferenceKeys.localeCode, 'pt');
      }

      state = const AppStartupState.ready();
    } catch (error) {
      state = AppStartupState.error(error.toString());
    }
  }
}
