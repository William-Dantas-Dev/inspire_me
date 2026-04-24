import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../application/favorites/controllers/favorites_removal_controller.dart';
import '../../../application/favorites/providers/favorite_quotes_provider.dart';
import '../../../application/favorites/providers/favorites_provider.dart';
import '../../../data/quotes/models/quote_model.dart';
import 'widgets/favorites_app_bar.dart';
import 'widgets/favorites_empty_state.dart';
import 'widgets/favorites_error_state.dart';
import 'widgets/favorites_list.dart';
import 'widgets/favorites_loading_state.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  final Set<int> _pendingRemovalIds = {};

  FavoritesRemovalController _buildRemovalController({
    required QuoteModel quote,
    required AppLocalizations l10n,
  }) {
    return FavoritesRemovalController(
      messenger: ScaffoldMessenger.of(context),
      removedMessage: l10n.favoriteRemoved,
      undoLabel: l10n.undo,
      onPending: () {
        if (!mounted) return;

        setState(() {
          _pendingRemovalIds.add(quote.id);
        });
      },
      onUndo: () {
        if (!mounted) return;

        setState(() {
          _pendingRemovalIds.remove(quote.id);
        });
      },
      onRemove: (id) async {
        await ref.read(favoritesProvider.notifier).toggleFavorite(id);

        if (!mounted) return;

        setState(() {
          _pendingRemovalIds.remove(id);
        });
      },
    );
  }

  Future<void> _handleUnfavorite({
    required QuoteModel quote,
    required AppLocalizations l10n,
  }) async {
    if (_pendingRemovalIds.contains(quote.id)) return;

    final controller = _buildRemovalController(
      quote: quote,
      l10n: l10n,
    );

    await controller.start(quote.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final favoriteQuotesState = ref.watch(favoriteQuotesProvider);

    return Scaffold(
      appBar: const FavoritesAppBar(),
      body: favoriteQuotesState.when(
        loading: () => const FavoritesLoadingState(),
        error: (error, stackTrace) => FavoritesErrorState(
          onRetry: () {
            ref.invalidate(favoriteQuotesProvider);
          },
        ),
        data: (quotes) {
          if (quotes.isEmpty) {
            return const FavoritesEmptyState();
          }

          return FavoritesList(
            quotes: quotes,
            pendingRemovalIds: _pendingRemovalIds,
            onUnfavorite: (quote) {
              _handleUnfavorite(
                quote: quote,
                l10n: l10n,
              );
            },
          );
        },
      ),
    );
  }
}