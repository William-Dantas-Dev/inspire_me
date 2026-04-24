import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../data/legal/legal_content_loader.dart';
import '../../legal/legal_page.dart';
import 'settings_card.dart';

class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SettingsCard(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline_rounded),
          title: Text(l10n.appVersion),
          subtitle: const Text('1.0.0'),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text(l10n.termsOfUse),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LegalPage(
                  title: l10n.termsOfUse,
                  type: LegalDocumentType.terms,
                ),
              ),
            );
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text(l10n.privacyPolicy),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LegalPage(
                  title: l10n.privacyPolicy,
                  type: LegalDocumentType.privacy,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
