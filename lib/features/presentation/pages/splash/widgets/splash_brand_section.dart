import 'package:flutter/material.dart';

class SplashBrandSection extends StatelessWidget {
  const SplashBrandSection({
    super.key,
    required this.appName,
    required this.subtitle,
  });

  final String appName;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.10),
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.20),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            size: 52,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          appName,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.80),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}