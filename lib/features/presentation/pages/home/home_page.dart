import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../application/quotes/providers/quote_provider.dart';
import 'widgets/greeting.dart';
import 'widgets/header.dart';
import 'widgets/main_card/main_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final quoteState = ref.watch(quoteProvider);
    // final favoritesState = ref.watch(favoritesProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 20),
              const Greeting(name: ""),
              const SizedBox(height: 30),
              MainCard(
                isLoading: quoteState.isLoading,
                hasError: quoteState.hasError,
                errorMessage: l10n.quoteLoadError,
                loadingText: l10n.loading,
                inspireAgainText: l10n.inspireAgain,
                category: quoteState.value?.category ?? 0,
                tags: quoteState.value?.tags ?? const [],
                isFavorite: true,
                quoteId: quoteState.value?.id,
                quoteText: quoteState.value?.text,
                author: quoteState.value?.author,
                onChangeQuote: () => ref.read(quoteProvider.notifier).refreshQuote(),
                onToggleFavorite: () {},
                onShare: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
