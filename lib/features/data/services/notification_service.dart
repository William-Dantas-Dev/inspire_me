import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../notifications/models/notification_settings_model.dart';
import 'notification_preferences_service.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'inspireme_quotes_channel';
  static const String _channelName = 'InspireMe Quotes';
  static const String _channelDescription =
      'Notifications with inspirational quotes';

  Future<void> init() async {
    await _configureLocalTimeZone();

    const androidSettings = AndroidInitializationSettings(
      '@drawable/ic_notification',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings: settings);
    await _createAndroidNotificationChannel();
    await requestPermissions();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();

    try {
      final timeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  Future<void> _createAndroidNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.createNotificationChannel(channel);
  }

  Future<void> requestPermissions() async {
    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();
  }

  NotificationDetails _notificationDetails({required bool vibrate}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
        enableVibration: vibrate,
      ),
    );
  }

  Future<void> replenishQueue({
    required String title,
    required List<String> messages,
    required NotificationPreferencesService preferences,
    required NotificationSettingsModel settings,
    int targetCount = 20,
    int intervalHours = 3,
  }) async {
    if (messages.isEmpty) return;

    if (!settings.enabled) {
      await cancelAll(preferences: preferences);
      return;
    }

    final pending = await _plugin.pendingNotificationRequests();
    final pendingCount = pending.length;

    if (pendingCount >= targetCount) {
      return;
    }

    final missingCount = targetCount - pendingCount;

    final savedLastScheduledAt = preferences.getLastScheduledAt();
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime cursor;

    if (savedLastScheduledAt != null) {
      final savedDate = tz.TZDateTime.from(savedLastScheduledAt, tz.local);
      cursor = savedDate.isAfter(now) ? savedDate : now;
    } else {
      cursor = now;
    }

    cursor = _normalizeCursorToWindow(
      cursor,
      startHour: settings.startHour,
      startMinute: settings.startMinute,
      endHour: settings.endHour,
      endMinute: settings.endMinute,
    );

    var nextId = preferences.getNextNotificationId();

    for (int i = 0; i < missingCount; i++) {
      cursor = _nextValidScheduledDate(
        from: cursor,
        intervalHours: intervalHours,
        startHour: settings.startHour,
        startMinute: settings.startMinute,
        endHour: settings.endHour,
        endMinute: settings.endMinute,
      );

      final messageIndex = (nextId - 1000) % messages.length;
      final message = messages[messageIndex];

      await _plugin.zonedSchedule(
        id: nextId,
        scheduledDate: cursor,
        notificationDetails: _notificationDetails(vibrate: settings.vibrate),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: message,
        matchDateTimeComponents: null,
      );

      nextId++;
    }

    await preferences.saveLastScheduledAt(cursor);
    await preferences.saveNextNotificationId(nextId);
  }

  tz.TZDateTime _normalizeCursorToWindow(
    tz.TZDateTime dateTime, {
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
  }) {
    final start = tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      startHour,
      startMinute,
    );

    final end = tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      endHour,
      endMinute,
    );

    if (dateTime.isBefore(start)) {
      return start;
    }

    if (dateTime.isAfter(end)) {
      return tz.TZDateTime(
        tz.local,
        dateTime.year,
        dateTime.month,
        dateTime.day + 1,
        startHour,
        startMinute,
      );
    }

    return dateTime;
  }

  tz.TZDateTime _nextValidScheduledDate({
    required tz.TZDateTime from,
    required int intervalHours,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
  }) {
    final candidate = from.add(Duration(hours: intervalHours));

    final start = tz.TZDateTime(
      tz.local,
      candidate.year,
      candidate.month,
      candidate.day,
      startHour,
      startMinute,
    );

    final end = tz.TZDateTime(
      tz.local,
      candidate.year,
      candidate.month,
      candidate.day,
      endHour,
      endMinute,
    );

    if (candidate.isBefore(start)) {
      return start;
    }

    if (candidate.isAfter(end)) {
      return tz.TZDateTime(
        tz.local,
        candidate.year,
        candidate.month,
        candidate.day + 1,
        startHour,
        startMinute,
      );
    }

    return candidate;
  }

  Future<void> rescheduleQueue({
    required String title,
    required List<String> messages,
    required NotificationPreferencesService preferences,
    required NotificationSettingsModel settings,
    int targetCount = 20,
    int intervalHours = 3,
  }) async {
    await cancelAll(preferences: preferences);

    if (!settings.enabled) {
      return;
    }

    await replenishQueue(
      title: title,
      messages: messages,
      preferences: preferences,
      settings: settings,
      targetCount: targetCount,
      intervalHours: intervalHours,
    );
  }

  Future<int> getPendingCount() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.length;
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  Future<void> cancelAll({NotificationPreferencesService? preferences}) async {
    await _plugin.cancelAll();

    if (preferences != null) {
      await preferences.clearNotificationSchedulingState();
    }
  }
}
