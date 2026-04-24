import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../application/locale/locale_provider.dart';

class SettingsLanguageTile extends ConsumerWidget {
  const SettingsLanguageTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final notifier = ref.read(localeProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    final currentLabel = _getLabel(locale.languageCode);

    return ListTile(
      leading: const Icon(Icons.language_rounded),
      title: Text(l10n.language),
      subtitle: Text(currentLabel),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => _showLanguageModal(context, notifier, locale),
    );
  }

  String _getLabel(String code) {
    switch (code) {
      case 'pt':
        return 'Português';
      case 'en':
        return 'English';
      default:
        return 'English';
    }
  }

  void _showLanguageModal(
    BuildContext context,
    LocaleNotifier notifier,
    Locale current,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (modalContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LanguageOption(
                label: 'Português',
                selected: current.languageCode == 'pt',
                onTap: () async {
                  Navigator.pop(modalContext);
                  await notifier.setLocale(const Locale('pt'));
                },
              ),
              _LanguageOption(
                label: 'English',
                selected: current.languageCode == 'en',
                onTap: () async {
                  Navigator.pop(modalContext);
                  await notifier.setLocale(const Locale('en'));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

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
