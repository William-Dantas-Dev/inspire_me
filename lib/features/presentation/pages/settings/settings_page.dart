import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import 'widgets/settings_about_section.dart';
import 'widgets/settings_card.dart';
import 'widgets/settings_language_tile.dart';
import 'widgets/settings_notifications_section.dart';
import 'widgets/settings_section_title.dart';
import 'widgets/settings_theme_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsSectionTitle(
            title: l10n.preferences,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 8),
          const SettingsCard(
            children: [
              SettingsLanguageTile(),
              Divider(height: 1),
              SettingsThemeTile(),
            ],
          ),
          const SizedBox(height: 24),
          SettingsSectionTitle(
            title: l10n.notificationSettingTitle,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 8),
          const SettingsNotificationsSection(),
          const SizedBox(height: 24),
          SettingsSectionTitle(title: l10n.about, color: colorScheme.primary),
          const SizedBox(height: 8),
          const SettingsAboutSection(),
        ],
      ),
    );
  }
}
