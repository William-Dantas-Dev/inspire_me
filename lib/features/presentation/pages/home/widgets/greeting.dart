import 'package:flutter/material.dart';

import '../../../../../core/utils/greeting_helper.dart';
import '../../../../../l10n/app_localizations.dart';

class Greeting extends StatelessWidget {
  final String? name;

  const Greeting({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final hasName = name != null && name!.isNotEmpty;

    return Text(
      hasName
          ? "${getGreeting(l10n)}, $name"
          : getGreeting(l10n),
      style: textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        height: 1.2,
      ),
    );
  }
}