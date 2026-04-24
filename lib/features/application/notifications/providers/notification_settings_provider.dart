import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../data/notifications/models/notification_settings_model.dart';
import '../../../data/notifications/models/notification_settings_service.dart';

final notificationSettingsServiceProvider =
    Provider<NotificationSettingsService>((ref) {
      final prefs = ref.read(sharedPreferencesProvider);
      return NotificationSettingsService(prefs);
    });

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettingsModel>(
      NotificationSettingsNotifier.new,
    );

class NotificationSettingsNotifier extends Notifier<NotificationSettingsModel> {
  @override
  NotificationSettingsModel build() {
    final service = ref.read(notificationSettingsServiceProvider);
    return service.loadSettings();
  }

  Future<void> updateEnabled(bool value) async {
    final updated = state.copyWith(enabled: value);
    await _save(updated);
  }

  Future<void> updateVibrate(bool value) async {
    final updated = state.copyWith(vibrate: value);
    await _save(updated);
  }

  Future<void> updateStartTime({required int hour, required int minute}) async {
    final updated = state.copyWith(startHour: hour, startMinute: minute);

    await _save(updated);
  }

  Future<void> updateEndTime({required int hour, required int minute}) async {
    final updated = state.copyWith(endHour: hour, endMinute: minute);

    await _save(updated);
  }

  Future<void> resetToDefaults() async {
    await _save(const NotificationSettingsModel.defaults());
  }

  Future<void> _save(NotificationSettingsModel settings) async {
    state = settings;

    final service = ref.read(notificationSettingsServiceProvider);
    await service.saveSettings(settings);
  }

  Future<void> saveSettings(NotificationSettingsModel settings) async {
    state = settings;

    final service = ref.read(notificationSettingsServiceProvider);
    await service.saveSettings(settings);
  }
}
