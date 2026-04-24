import 'package:flutter/material.dart';

import '../../../../../core/routes/route_names.dart';
import '../../../../../l10n/app_localizations.dart';

class Header extends StatelessWidget {
  const Header({super.key});

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
          onPressed: () {   
            Navigator.pushNamed(context, RouteNames.favorites);
          },
          icon: Icon(Icons.favorite_border, color: colorScheme.primary),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.settings);
          },
          icon: Icon(Icons.settings, color: colorScheme.primary),
        ),
      ],
    );
  }
}
