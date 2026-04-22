import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../data/services/locale_preferences_service.dart';

final localePreferencesServiceProvider = Provider<LocalePreferencesService>((
  ref,
) {
  final prefs = ref.read(sharedPreferencesProvider);
  return LocalePreferencesService(prefs);
});

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final service = ref.read(localePreferencesServiceProvider);
    return service.loadLocale() ?? const Locale('pt');
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;

    state = locale;

    final service = ref.read(localePreferencesServiceProvider);
    await service.saveLocale(locale);
  }

  Future<void> setPortuguese() async {
    await setLocale(const Locale('pt'));
  }

  Future<void> setEnglish() async {
    await setLocale(const Locale('en'));
  }

  Future<void> resetToDefault() async {
    state = const Locale('pt');

    final service = ref.read(localePreferencesServiceProvider);
    await service.saveLocale(const Locale('pt'));
  }
}
