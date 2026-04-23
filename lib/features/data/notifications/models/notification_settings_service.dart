import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_settings_model.dart';

class NotificationSettingsService {
  NotificationSettingsService(this._prefs);

  final SharedPreferences _prefs;

  static const _enabledKey = 'notification_enabled';
  static const _startHourKey = 'notification_start_hour';
  static const _startMinuteKey = 'notification_start_minute';
  static const _endHourKey = 'notification_end_hour';
  static const _endMinuteKey = 'notification_end_minute';
  static const _vibrateKey = 'notification_vibrate';

  NotificationSettingsModel loadSettings() {
    return NotificationSettingsModel(
      enabled: _prefs.getBool(_enabledKey) ?? true,
      startHour: _prefs.getInt(_startHourKey) ?? 8,
      startMinute: _prefs.getInt(_startMinuteKey) ?? 0,
      endHour: _prefs.getInt(_endHourKey) ?? 22,
      endMinute: _prefs.getInt(_endMinuteKey) ?? 0,
      vibrate: _prefs.getBool(_vibrateKey) ?? true,
    );
  }

  Future<void> saveSettings(NotificationSettingsModel settings) async {
    await _prefs.setBool(_enabledKey, settings.enabled);
    await _prefs.setInt(_startHourKey, settings.startHour);
    await _prefs.setInt(_startMinuteKey, settings.startMinute);
    await _prefs.setInt(_endHourKey, settings.endHour);
    await _prefs.setInt(_endMinuteKey, settings.endMinute);
    await _prefs.setBool(_vibrateKey, settings.vibrate);
  }

  Future<void> resetToDefaults() async {
    await saveSettings(const NotificationSettingsModel.defaults());
  }
}