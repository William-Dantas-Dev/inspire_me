import 'package:flutter/material.dart';

import 'action_icon.dart';

class CardActions extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const CardActions({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.onShare,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ActionIcon(
              icon: isFavorite ? Icons.favorite : Icons.favorite_border,
              onTap: onFavorite,
            ),
            const SizedBox(width: 12),
            ActionIcon(icon: Icons.share, onTap: onShare),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
        ),
      ],
    );
  }
}
