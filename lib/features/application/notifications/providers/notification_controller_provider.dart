import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../data/notifications/models/notification_settings_model.dart';
import '../../../data/services/notification_preferences_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/quotes/providers/quotes_provider.dart';
import 'notification_settings_provider.dart';

final notificationControllerProvider =
    Provider<NotificationController>((ref) {
  return NotificationController(ref);
});

class NotificationController {
  NotificationController(this._ref);

  final Ref _ref;

  Future<void> applySettings({
    required NotificationSettingsModel settings,
    required String appName,
  }) async {
    final settingsNotifier =
        _ref.read(notificationSettingsProvider.notifier);

    await settingsNotifier.saveSettings(settings);

    final prefs = _ref.read(sharedPreferencesProvider);
    final notificationPreferences = NotificationPreferencesService(prefs);

    final quotes = await _ref.read(quotesProvider.future);
    final messages = quotes.map((quote) => quote.text).toList();

    await NotificationService.instance.rescheduleQueue(
      title: appName,
      messages: messages,
      preferences: notificationPreferences,
      settings: settings,
      targetCount: 20,
      intervalHours: 3,
    );
  }
}