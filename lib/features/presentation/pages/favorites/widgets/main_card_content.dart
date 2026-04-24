import 'package:flutter/material.dart';

import 'main_card_tags.dart';

class MainCardContent extends StatelessWidget {
  final String quoteText;
  final String? author;
  final List<String> tags;

  const MainCardContent({
    super.key,
    required this.quoteText,
    required this.author,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          quoteText,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            height: 1.3,
            shadows: const [
              Shadow(
                blurRadius: 8,
                offset: Offset(0, 2),
                color: Colors.black26,
              ),
            ],
          ),
        ),
        if (author != null && author!.trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '— $author',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          MainCardTags(tags: tags.take(3).toList()),
        ],
      ],
    );
  }
}