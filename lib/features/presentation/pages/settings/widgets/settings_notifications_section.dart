import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/notifications/providers/notification_controller_provider.dart';
import '../../../../application/notifications/providers/notification_settings_provider.dart';
import 'settings_card.dart';

class SettingsNotificationsSection extends ConsumerWidget {
  const SettingsNotificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(notificationSettingsProvider);
    final controller = ref.read(notificationControllerProvider);

    return SettingsCard(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.notifications_active_rounded),
          title: Text(l10n.notificationSettingTitle),
          subtitle: Text(l10n.notificationSettingSubtitle),
          value: settings.enabled,
          onChanged: (value) async {
            await controller.applySettings(
              appName: l10n.appName,
              settings: settings.copyWith(enabled: value),
            );
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.schedule_rounded),
          title: Text(l10n.notificationStartTime),
          subtitle: Text(_formatTime(settings.startHour, settings.startMinute)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () async {
            final picked = await _pickTime(
              context,
              initialHour: settings.startHour,
              initialMinute: settings.startMinute,
            );

            if (picked == null) return;

            await controller.applySettings(
              appName: l10n.appName,
              settings: settings.copyWith(
                startHour: picked.hour,
                startMinute: picked.minute,
              ),
            );
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.schedule_outlined),
          title: Text(l10n.notificationEndTime),
          subtitle: Text(_formatTime(settings.endHour, settings.endMinute)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () async {
            final picked = await _pickTime(
              context,
              initialHour: settings.endHour,
              initialMinute: settings.endMinute,
            );

            if (picked == null) return;

            await controller.applySettings(
              appName: l10n.appName,
              settings: settings.copyWith(
                endHour: picked.hour,
                endMinute: picked.minute,
              ),
            );
          },
        ),
        const Divider(height: 1),
        SwitchListTile(
          secondary: const Icon(Icons.vibration_rounded),
          title: Text(l10n.notificationVibration),
          subtitle: Text(l10n.notificationVibrationSubtitle),
          value: settings.vibrate,
          onChanged: settings.enabled
              ? (value) async {
                  await controller.applySettings(
                    appName: l10n.appName,
                    settings: settings.copyWith(vibrate: value),
                  );
                }
              : null,
        ),
      ],
    );
  }

  Future<TimeOfDay?> _pickTime(
    BuildContext context, {
    required int initialHour,
    required int initialMinute,
  }) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
    );
  }

  String _formatTime(int hour, int minute) {
    final formattedHour = hour.toString().padLeft(2, '0');
    final formattedMinute = minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute';
  }
}
