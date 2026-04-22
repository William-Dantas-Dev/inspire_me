import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/quote_category_model.dart';
import '../models/quote_model.dart';

class LocalQuotesDataSource {
  Future<List<QuoteModel>> loadQuotes({
    required String languageCode,
  }) async {
    final path = 'assets/data/$languageCode/quotes.json';

    final rawJson = await rootBundle.loadString(path);
    final decoded = jsonDecode(rawJson) as List<dynamic>;

    return decoded
        .map((item) => QuoteModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<QuoteCategoryModel>> loadCategories({
    required String languageCode,
  }) async {
    final path = 'assets/data/$languageCode/categories.json';

    final rawJson = await rootBundle.loadString(path);
    final decoded = jsonDecode(rawJson) as List<dynamic>;

    return decoded
        .map((item) => QuoteCategoryModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}