import 'package:flutter/material.dart';

import '../../../../../core/utils/category_color_resolver.dart';
import 'main_card_background.dart';
import 'main_card_content.dart';

class ShareableQuoteCard extends StatelessWidget {
  const ShareableQuoteCard({
    super.key,
    required this.quoteText,
    required this.author,
    required this.tags,
    required this.category,
  });

  final String quoteText;
  final String author;
  final List<String> tags;
  final int category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categoryColor = resolveCategoryColor(
      category: category,
      colorScheme: theme.colorScheme,
    );

    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MainCardBackground(categoryColor: categoryColor),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: MainCardContent(
              quoteText: quoteText,
              author: author,
              tags: tags,
            ),
          ),
        ],
      ),
    );
  }
}