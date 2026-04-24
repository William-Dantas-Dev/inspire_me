import 'package:flutter/material.dart';

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const ActionIcon({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isDisabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: isDisabled
              ? colorScheme.surface.withValues(alpha: 0.3)
              : colorScheme.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 18,
          color: isDisabled
              ? colorScheme.onSurface.withValues(alpha: 0.4)
              : colorScheme.primary,
        ),
      ),
    );
  }
}
