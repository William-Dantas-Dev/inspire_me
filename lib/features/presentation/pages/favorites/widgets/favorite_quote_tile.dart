import 'package:flutter/material.dart';

import '../../../../data/quotes/models/quote_model.dart';

class FavoriteQuoteTile extends StatelessWidget {
  const FavoriteQuoteTile({
    super.key,
    required this.quote,
    required this.onUnfavorite,
    required this.onShare,
    required this.pendingRemovalText,
    required this.shareTooltip,
    required this.removeTooltip,
    required this.pendingRemovalTooltip,
    this.isPendingRemoval = false,
  });

  final QuoteModel quote;
  final VoidCallback onUnfavorite;
  final VoidCallback onShare;
  final String pendingRemovalText;
  final String shareTooltip;
  final String removeTooltip;
  final String pendingRemovalTooltip;
  final bool isPendingRemoval;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final author = quote.author;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isPendingRemoval ? 0.55 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPendingRemoval
                ? theme.colorScheme.error.withValues(alpha: 0.35)
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: isPendingRemoval
              ? theme.colorScheme.errorContainer.withValues(alpha: 0.18)
              : theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quote.text,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '- $author',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (quote.tags.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: quote.tags
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    tag,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: theme
                                              .colorScheme
                                              .onSecondaryContainer,
                                        ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      if (isPendingRemoval) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 16,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              pendingRemovalText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: shareTooltip,
                      onPressed: onShare,
                      icon: Icon(
                        Icons.share_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      tooltip: isPendingRemoval
                          ? pendingRemovalTooltip
                          : removeTooltip,
                      onPressed: isPendingRemoval ? null : onUnfavorite,
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isPendingRemoval
                              ? Icons.favorite_border_rounded
                              : Icons.favorite_rounded,
                          key: ValueKey(isPendingRemoval),
                          color: isPendingRemoval
                              ? theme.disabledColor
                              : theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
