class NotificationSettingsModel {
  const NotificationSettingsModel({
    required this.enabled,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.vibrate,
  });

  final bool enabled;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final bool vibrate;

  const NotificationSettingsModel.defaults()
      : enabled = true,
        startHour = 8,
        startMinute = 0,
        endHour = 22,
        endMinute = 0,
        vibrate = true;

  NotificationSettingsModel copyWith({
    bool? enabled,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    bool? vibrate,
  }) {
    return NotificationSettingsModel(
      enabled: enabled ?? this.enabled,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      vibrate: vibrate ?? this.vibrate,
    );
  }
}