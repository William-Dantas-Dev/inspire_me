import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.onOpenFavorites,
    required this.onOpenSettings,
  });

  final VoidCallback onOpenFavorites;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Text(
          l10n.appName,
          style: textTheme.titleMedium?.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onOpenFavorites,
          icon: Icon(Icons.favorite_border, color: colorScheme.primary),
        ),
        IconButton(
          onPressed: onOpenSettings,
          icon: Icon(Icons.settings, color: colorScheme.primary),
        ),
      ],
    );
  }
}
