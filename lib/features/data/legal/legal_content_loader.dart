import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

enum LegalDocumentType {
  terms,
  privacy,
}

class LegalContentLoader {
  static Future<String> load({
    required BuildContext context,
    required LegalDocumentType type,
  }) async {
    final locale = Localizations.localeOf(context).languageCode;

    // Define idioma (fallback para inglês)
    final lang = locale == 'pt' ? 'pt' : 'en';

    // Define arquivo
    final fileName = switch (type) {
      LegalDocumentType.terms => 'terms.md',
      LegalDocumentType.privacy => 'privacy.md',
    };

    final path = 'assets/legal/$lang/$fileName';

    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      // fallback caso dê erro
      return 'Error loading document.';
    }
  }
}