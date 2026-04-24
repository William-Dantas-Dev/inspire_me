import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_preferences_provider.dart';

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, Set<int>>(
  FavoritesNotifier.new,
);

class FavoritesNotifier extends AsyncNotifier<Set<int>> {
  static const _favoritesKey = 'favorite_quote_ids';

  @override
  Future<Set<int>> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final storedIds = prefs.getStringList(_favoritesKey) ?? [];

    return storedIds
        .map(int.tryParse)
        .whereType<int>()
        .toSet();
  }

  Future<void> toggleFavorite(int quoteId) async {
    final currentFavorites = state.value ?? <int>{};

    final updatedFavorites = {...currentFavorites};

    if (updatedFavorites.contains(quoteId)) {
      updatedFavorites.remove(quoteId);
    } else {
      updatedFavorites.add(quoteId);
    }

    state = AsyncData(updatedFavorites);

    final prefs = ref.read(sharedPreferencesProvider);

    await prefs.setStringList(
      _favoritesKey,
      updatedFavorites.map((id) => id.toString()).toList(),
    );
  }

  bool isFavorite(int quoteId) {
    final currentFavorites = state.value ?? <int>{};
    return currentFavorites.contains(quoteId);
  }
}