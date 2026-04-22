import '../datasources/local_quotes_datasource.dart';
import '../models/quote_category_model.dart';
import '../models/quote_model.dart';

class QuotesRepository {
  QuotesRepository(this._dataSource);

  final LocalQuotesDataSource _dataSource;

  Future<List<QuoteModel>> getQuotes({
    required String languageCode,
  }) async {
    final quotes = await _dataSource.loadQuotes(
      languageCode: languageCode,
    );

    return quotes.where((quote) => quote.active).toList();
  }

  Future<List<QuoteCategoryModel>> getCategories({
    required String languageCode,
  }) async {
    return _dataSource.loadCategories(
      languageCode: languageCode,
    );
  }
}