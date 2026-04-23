import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferencesService {
  NotificationPreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const _lastScheduledAtKey = 'notifications_last_scheduled_at';
  static const _nextIdKey = 'notifications_next_id';

  DateTime? getLastScheduledAt() {
    final value = _prefs.getString(_lastScheduledAtKey);
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  Future<void> saveLastScheduledAt(DateTime dateTime) async {
    await _prefs.setString(_lastScheduledAtKey, dateTime.toIso8601String());
  }

  int getNextNotificationId() {
    return _prefs.getInt(_nextIdKey) ?? 1000;
  }

  Future<void> saveNextNotificationId(int id) async {
    await _prefs.setInt(_nextIdKey, id);
  }

  Future<void> clearNotificationSchedulingState() async {
    await _prefs.remove(_lastScheduledAtKey);
    await _prefs.remove(_nextIdKey);
  }
}