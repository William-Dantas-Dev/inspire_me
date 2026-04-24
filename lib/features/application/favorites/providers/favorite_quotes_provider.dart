import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/quotes/models/quote_model.dart';
import '../../../data/quotes/providers/quotes_provider.dart';
import 'favorites_provider.dart';

final favoriteQuotesProvider = FutureProvider<List<QuoteModel>>((ref) async {
  final favoriteIds = await ref.watch(favoritesProvider.future);
  final quotes = await ref.watch(quotesProvider.future);

  return quotes.where((quote) => favoriteIds.contains(quote.id)).toList();
});