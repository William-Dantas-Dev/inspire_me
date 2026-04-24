import 'package:flutter/material.dart';

import '../../../../data/quotes/models/quote_model.dart';
import '../../../../../l10n/app_localizations.dart';
import 'favorite_quote_tile.dart';
import 'quote_share_dialog.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({
    super.key,
    required this.quotes,
    required this.pendingRemovalIds,
    required this.onUnfavorite,
  });

  final List<QuoteModel> quotes;
  final Set<int> pendingRemovalIds;
  final ValueChanged<QuoteModel> onUnfavorite;

  Future<void> _openSharePreview(BuildContext context, QuoteModel quote) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => QuoteShareDialog(
        quoteText: quote.text,
        author: quote.author,
        tags: quote.tags,
        category: quote.category,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: quotes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final quote = quotes[index];
        final isPendingRemoval = pendingRemovalIds.contains(quote.id);

        return FavoriteQuoteTile(
          quote: quote,
          isPendingRemoval: isPendingRemoval,
          pendingRemovalText: l10n.favoritePendingRemoval,
          shareTooltip: l10n.favoriteShareTooltip,
          removeTooltip: l10n.favoriteRemoveTooltip,
          pendingRemovalTooltip: l10n.favoritePendingTooltip,
          onUnfavorite: () => onUnfavorite(quote),
          onShare: () => _openSharePreview(context, quote),
        );
      },
    );
  }
}
