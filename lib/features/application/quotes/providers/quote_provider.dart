import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../locale/locale_provider.dart';
import '../../../data/quotes/models/quote_model.dart';
import '../../../data/quotes/providers/quotes_provider.dart';

final quoteProvider =
    AsyncNotifierProvider.autoDispose<QuoteNotifier, QuoteModel>(
      QuoteNotifier.new,
    );

class QuoteNotifier extends AsyncNotifier<QuoteModel> {
  @override
  Future<QuoteModel> build() async {
    return _getRandomQuote();
  }

  Future<QuoteModel> _getRandomQuote() async {
    final locale = ref.watch(localeProvider);
    final quotes = await ref.watch(quotesProvider.future);

    final activeQuotes = quotes.where((quote) => quote.active).toList();

    if (activeQuotes.isEmpty) {
      throw Exception('No active quotes found for ${locale.languageCode}');
    }

    final random = Random();
    return activeQuotes[random.nextInt(activeQuotes.length)];
  }

  Future<void> refreshQuote() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return _getRandomQuote();
    });
  }
}
