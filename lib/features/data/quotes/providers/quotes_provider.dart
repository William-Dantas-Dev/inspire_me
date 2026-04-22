import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/locale/locale_provider.dart';
import '../datasources/local_quotes_datasource.dart';
import '../models/quote_category_model.dart';
import '../models/quote_model.dart';
import '../repositories/quotes_repository.dart';

final localQuotesDataSourceProvider = Provider<LocalQuotesDataSource>((ref) {
  return LocalQuotesDataSource();
});

final quotesRepositoryProvider = Provider<QuotesRepository>((ref) {
  final dataSource = ref.read(localQuotesDataSourceProvider);
  return QuotesRepository(dataSource);
});

final quotesProvider = FutureProvider<List<QuoteModel>>((ref) async {
  final locale = ref.watch(localeProvider);
  final repository = ref.read(quotesRepositoryProvider);

  return repository.getQuotes(
    languageCode: locale.languageCode,
  );
});

final quoteCategoriesProvider =
    FutureProvider<List<QuoteCategoryModel>>((ref) async {
      final locale = ref.watch(localeProvider);
      final repository = ref.read(quotesRepositoryProvider);

      return repository.getCategories(
        languageCode: locale.languageCode,
      );
    });