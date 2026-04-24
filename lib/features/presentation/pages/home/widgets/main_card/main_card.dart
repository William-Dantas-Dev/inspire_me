import 'package:flutter/material.dart';

import '../../../../../../core/utils/category_color_resolver.dart';
import 'card_actions.dart';
import 'main_card_background.dart';
import 'main_card_content.dart';
import 'main_card_error.dart';
import 'main_card_loading.dart';

class MainCard extends StatelessWidget {
  const MainCard({
    super.key,
    required this.repaintBoundaryKey,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.loadingText,
    required this.inspireAgainText,
    required this.category,
    required this.tags,
    required this.isFavorite,
    required this.onChangeQuote,
    required this.onToggleFavorite,
    required this.onShare,
    this.quoteId,
    this.quoteText,
    this.author,
  });

  final GlobalKey repaintBoundaryKey;

  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final String loadingText;
  final String inspireAgainText;

  final int category;
  final List<String> tags;
  final bool isFavorite;

  final int? quoteId;
  final String? quoteText;
  final String? author;

  final VoidCallback onChangeQuote;
  final VoidCallback onToggleFavorite;
  final VoidCallback onShare;

  bool get _hasQuote => quoteId != null && quoteText != null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final categoryColor = resolveCategoryColor(
      category: category,
      colorScheme: colorScheme,
    );

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: RepaintBoundary(
                key: repaintBoundaryKey,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MainCardBackground(categoryColor: categoryColor),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _buildContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          CardActions(
            buttonText: isLoading ? loadingText : inspireAgainText,
            onPressed: isLoading ? null : onChangeQuote,
            onShare: (!_hasQuote || isLoading) ? null : onShare,
            onFavorite: (!_hasQuote || isLoading) ? null : onToggleFavorite,
            isFavorite: isFavorite,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const MainCardLoading(key: ValueKey('loading...'));
    }

    if (hasError) {
      return MainCardError(
        key: const ValueKey('error'),
        message: errorMessage,
        onRetry: onChangeQuote,
      );
    }

    if (!_hasQuote) {
      return MainCardError(
        key: const ValueKey('empty'),
        message: errorMessage,
        onRetry: onChangeQuote,
      );
    }

    return MainCardContent(
      key: ValueKey('quoteId'),
      quoteText: quoteText!,
      author: author,
      tags: tags,
    );
  }
}