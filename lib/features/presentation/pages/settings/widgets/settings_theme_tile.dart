import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../application/theme/theme_mode_provider.dart';

class SettingsThemeTile extends ConsumerWidget {
  const SettingsThemeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Icons.palette_rounded),
      title: Text(l10n.theme),
      subtitle: Text(_themeModeLabel(l10n, themeMode)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => _showThemeModal(
        context: context,
        notifier: notifier,
        currentMode: themeMode,
        l10n: l10n,
      ),
    );
  }

  void _showThemeModal({
    required BuildContext context,
    required ThemeModeNotifier notifier,
    required ThemeMode currentMode,
    required AppLocalizations l10n,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (modalContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ThemeOption(
                label: l10n.themeSystem,
                selected: currentMode == ThemeMode.system,
                onTap: () async {
                  Navigator.pop(modalContext);
                  await notifier.setSystemMode();
                },
              ),
              _ThemeOption(
                label: l10n.themeLight,
                selected: currentMode == ThemeMode.light,
                onTap: () async {
                  Navigator.pop(modalContext);
                  await notifier.setLightMode();
                },
              ),
              _ThemeOption(
                label: l10n.themeDark,
                selected: currentMode == ThemeMode.dark,
                onTap: () async {
                  Navigator.pop(modalContext);
                  await notifier.setDarkMode();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _themeModeLabel(AppLocalizations l10n, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return l10n.themeSystem;
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
    }
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: selected
          ? Icon(
              Icons.check_rounded,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}