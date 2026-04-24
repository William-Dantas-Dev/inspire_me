import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../application/favorites/providers/favorites_provider.dart';
import '../../../application/quotes/providers/quote_provider.dart';
import '../../../application/share/share_card_service.dart';
import '../../../application/share/share_message_builder.dart';
import 'widgets/greeting.dart';
import 'widgets/header.dart';
import 'widgets/main_card/main_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey _cardKey = GlobalKey();

  final ShareCardService _shareCardService = const ShareCardService();
  final ShareMessageBuilder _shareMessageBuilder = const ShareMessageBuilder();

  bool _isSharing = false;

  Future<void> _shareCurrentQuote() async {
    if (_isSharing) return;

    final quoteState = ref.read(quoteProvider);
    final quote = quoteState.value;

    if (quote == null) return;

    final cardContext = _cardKey.currentContext;
    final l10n = AppLocalizations.of(context)!;

    if (cardContext == null) return;

    final renderObject = cardContext.findRenderObject();

    if (renderObject is! RenderRepaintBoundary) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final shareText = _shareMessageBuilder.build(
        appName: l10n.appName,
        quoteText: quote.text,
        author: quote.author,
      );

      await _shareCardService.shareRepaintBoundary(
        boundary: renderObject,
        fileName: 'quote.png',
        text: shareText,
      );
    } catch (error) {
      debugPrint('Erro ao compartilhar card: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.shareImageError)));
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final quoteState = ref.watch(quoteProvider);
    final favoritesState = ref.watch(favoritesProvider);

    final quote = quoteState.value;

    final isFavorite = quote == null
        ? false
        : favoritesState.maybeWhen(
            data: (favoriteIds) => favoriteIds.contains(quote.id),
            orElse: () => false,
          );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                onOpenFavorites: () {
                  Navigator.pushNamed(context, RouteNames.favorites);
                },
                onOpenSettings: () {
                  Navigator.pushNamed(context, RouteNames.settings);
                },
              ),
              const SizedBox(height: 20),
              const Greeting(name: ""),
              const SizedBox(height: 30),
              MainCard(
                repaintBoundaryKey: _cardKey,
                isLoading: quoteState.isLoading,
                hasError: quoteState.hasError,
                errorMessage: l10n.quoteLoadError,
                loadingText: l10n.loading,
                inspireAgainText: l10n.inspireAgain,
                category: quote?.category ?? 0,
                tags: quote?.tags ?? const [],
                isFavorite: isFavorite,
                quoteId: quote?.id,
                quoteText: quote?.text,
                author: quote?.author,
                onChangeQuote: () async {
                  await ref.read(quoteProvider.notifier).refreshQuote();
                },
                onToggleFavorite: () async {
                  if (quote == null) return;

                  await ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(quote.id);
                },
                onShare: _shareCurrentQuote,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
